local darkWallpaper = hs.configdir .. "/wallpapers/catalina.jpg"
local lightWallpaper = hs.configdir .. "/wallpapers/forest.jpg"

local activeTasks = {}
local cmdTemplate = [=[
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# 0. Update theme cache (kept synchronous so subsequent reads get the correct state instantly)
mkdir -p $HOME/.cache/zsh
echo "{{THEME_LOWER}}" > $HOME/.cache/zsh/theme

# 1. Set macOS System Appearance asynchronously (avoids spawning a separate Hammerspoon task)
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to {{DARK_MODE}}' >/dev/null 2>&1 < /dev/null &!

# 2. Hot-reload active terminal zsh shells to update their FZF/Bat themes
{
  pids=$(ps -ww -o pid= -o tty= -o args= | awk '$2 != "??" && ($3 ~ /(\/|^)-?zsh$/) {
    interactive = 1
    for (i = 4; i <= NF; i++) {
      if ($i !~ /^-[il]+$/ && $i !~ /^--(login|interactive)$/) {
        interactive = 0
        break
      }
    }
    if (interactive) print $1
  }')
  [ -n "$pids" ] && kill -{{SIGNAL}} ${=pids}
} >/dev/null 2>&1 < /dev/null &!

# 3. Command all active Neovim instances to set background mode (bypasses all configs, defaults, and Shada)
{
  for s in $HOME/.cache/nvim/sockets/nvim-*.sock(N); do
    if [ -S "$s" ]; then
      filename=${s##*/}
      pid=${filename#nvim-}
      pid=${pid%.sock}
      if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        nvim --headless -u NONE -i NONE --server "$s" --remote-expr "luaeval('pcall(function() vim.o.background=\"{{THEME_LOWER}}\" end)', '')" >/dev/null 2>&1 < /dev/null &!
      else
        rm "$s" # Kept synchronous within the backgrounded loop to avoid process-forking overhead
      fi
    fi
  done
} >/dev/null 2>&1 < /dev/null &!

# 4. Hot-reload Tmux config
pgrep tmux >/dev/null && {
  [ -f "$HOME/.tmux/{{THEME_LOWER}}.conf" ] && tmux source-file "$HOME/.tmux/{{THEME_LOWER}}.conf"
  tmux list-clients -F '#{client_name}' 2>/dev/null | xargs -I {} tmux refresh-client -t '{}'
} >/dev/null 2>&1 < /dev/null &!

# 5. Update other file-based app configurations (Consolidated to save 3 process forks)
{
  # 5a. Update Gemini CLI settings
  [ -f $HOME/.gemini/settings.json ] && plutil -replace ui.theme -string "{{PLUTIL_THEME}}" $HOME/.gemini/settings.json >/dev/null 2>&1 && plutil -convert json $HOME/.gemini/settings.json >/dev/null 2>&1

  # 5b. Update k9s configuration skin
  for dir in "$HOME/.config/k9s" "$HOME/Library/Application Support/k9s"; do
    [ -d "$dir/skins" ] && {
      cp -f "$dir/skins/{{THEME_LOWER}}.yaml" "$dir/skins/current.yaml"
      touch "$dir/config.yaml" 2>/dev/null
    }
  done

  # 5c. Update btop configuration theme and notify running instances
  [ -f $HOME/.config/btop/btop.conf ] && {
    sed -i '' \
      -e 's/^color_theme = .*/color_theme = "{{BTOP_THEME}}"/' \
      -e 's/^theme_background = .*/theme_background = False/' \
      -e 's/^vim_keys = .*/vim_keys = True/' \
      $HOME/.config/btop/btop.conf && pkill -USR2 -x btop
  }

  # 5d. Update Kitty configuration theme and notify running instances
  [ -f $HOME/.config/kitty/kitty.conf ] && {
    cp -f $HOME/.config/kitty/{{THEME_LOWER}}-theme.auto.conf $HOME/.config/kitty/current-theme.conf && pkill -USR1 -x kitty
  }
} >/dev/null 2>&1 < /dev/null &!
]=]

Hyper:bind({}, "/", function()
  local isDark = hs.host.interfaceStyle() == "Dark"
  isDark = not isDark

  local theme = isDark and "Dark" or "Light"
  local wallpaper = isDark and darkWallpaper or lightWallpaper
  local signal = isDark and "USR1" or "USR2"
  local plutilTheme = isDark and "Default" or "Default Light"
  local btopTheme = isDark and "tokyo-storm" or "kanagawa-lotus"

  hs.console.darkMode(isDark)

  local targetURL = hs.fs.urlFromPath(wallpaper)
  if targetURL then
    -- Defer heavy GUI wallpaper operations to the next loop tick for instant tactile hotkey feedback
    hs.timer.doAfter(0, function()
      for _, screen in ipairs(hs.screen.allScreens()) do
        if screen:desktopImageURL() ~= targetURL then
          screen:desktopImageURL(targetURL)
        end
      end
    end)
  end

  -- Spawn ONE single asynchronous background zsh task for all global actions
  local themeLower = theme:lower()
  local replacements = {
    BTOP_THEME = btopTheme,
    DARK_MODE = tostring(isDark),
    PLUTIL_THEME = plutilTheme,
    SIGNAL = signal,
    THEME_LOWER = themeLower,
  }
  local cmd = cmdTemplate:gsub("{{([%w_]+)}}", replacements)

  local zshTask
  zshTask = hs.task.new("/bin/zsh", function()
    activeTasks[zshTask] = nil
  end, { "-c", cmd })

  activeTasks[zshTask] = true
  zshTask:start()
end)

--- Returning this to make the linter happy
return activeTasks
