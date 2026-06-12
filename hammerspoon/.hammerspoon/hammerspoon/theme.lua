local darkWallpaper = hs.configdir .. "/wallpapers/catalina.jpg"
local lightWallpaper = hs.configdir .. "/wallpapers/forest.jpg"

local activeTasks = {}

local scriptTemplate = 'tell app "System Events" to tell appearance preferences to set dark mode to %s'

local cmdTemplate = [=[
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# 0. Update theme cache
mkdir -p $HOME/.cache
echo "{{THEME_LOWER}}" > $HOME/.cache/theme

# 1. Hot-reload active terminal zsh shells to update their FZF/Bat themes
{
  pids=$(ps -ww -o pid= -o tty= -o args= | awk '$2 != "??" && ($3 ~ /(\/|^)-?zsh$/) {
    interactive = 1
    for (i = 4; i <= NF; i++) {
      if ($i !~ /^(-l|--login|-i|--interactive)$/) {
        interactive = 0
        break
      }
    }
    if (interactive) print $1
  }')
  [ -n "$pids" ] && kill -{{SIGNAL}} ${=pids}
} >/dev/null 2>&1 &

# 2. Command all active Neovim instances to set background mode
{
  for s in $HOME/.cache/nvim/sockets/nvim-*.sock(N); do
    if [ -S "$s" ]; then
      filename=${s##*/}
      pid=${filename#nvim-}
      pid=${pid%.sock}
      if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        nvim --server "$s" --remote-expr "luaeval('pcall(function() vim.o.background=\"{{THEME_LOWER}}\" end)', '')" 2>/dev/null &
      else
        rm "$s"
      fi
    fi
  done
} >/dev/null 2>&1 &

# 3. Hot-reload Tmux config
pgrep tmux >/dev/null && {
  tmux source-file $HOME/.tmux/{{THEME_LOWER}}.conf
  tmux list-clients -F '#{client_name}' 2>/dev/null | xargs -I {} tmux refresh-client -t '{}'
} >/dev/null 2>&1 &

# 4. Update Gemini CLI settings
[ -f $HOME/.gemini/settings.json ] && plutil -replace ui.theme -string "{{PLUTIL_THEME}}" $HOME/.gemini/settings.json >/dev/null 2>&1 && plutil -convert json $HOME/.gemini/settings.json >/dev/null 2>&1 &

# 5. Update k9s configuration skin
for dir in "$HOME/.config/k9s" "$HOME/Library/Application Support/k9s"; do
  [ -d "$dir/skins" ] && {
    cp -f "$dir/skins/{{THEME_LOWER}}.yaml" "$dir/skins/current.yaml"
    touch "$dir/config.yaml" 2>/dev/null
  }
done

# 6. Update btop configuration theme and notify running instances
[ -f $HOME/.config/btop/btop.conf ] && {
  sed -i '' \
    -e 's/^color_theme = .*/color_theme = "{{BTOP_THEME}}"/' \
    -e 's/^theme_background = .*/theme_background = False/' \
    -e 's/^vim_keys = .*/vim_keys = True/' \
    $HOME/.config/btop/btop.conf && pkill -USR2 -x btop
} >/dev/null 2>&1 &

# 7. Update Kitty configuration theme and notify running instances
[ -f $HOME/.config/kitty/kitty.conf ] && {
  cp -f $HOME/.config/kitty/{{THEME_LOWER}}-theme.auto.conf $HOME/.config/kitty/current-theme.conf && pkill -USR1 -x kitty
} >/dev/null 2>&1 &
]=]

Hyper:bind({}, "/", function()
  local darkMode = hs.host.interfaceStyle() == "Dark"
  local newMode = not darkMode

  local theme = newMode and "Dark" or "Light"
  local wallpaper = newMode and darkWallpaper or lightWallpaper
  local signal = newMode and "USR1" or "USR2"
  local plutilTheme = newMode and "Default" or "Default Light"
  local btopTheme = newMode and "tokyo-storm" or "kanagawa-lotus"

  local script = string.format(scriptTemplate, tostring(newMode))
  local osascriptTask
  osascriptTask = hs.task.new("/usr/bin/osascript", function(exitCode, stdErr)
    if exitCode ~= 0 then
      hs.log
        .new("theme", "error")
        :e("osascript failed with exit code " .. tostring(exitCode) .. ": " .. tostring(stdErr))
    end
    activeTasks[osascriptTask] = nil
  end, { "-e", script })
  activeTasks[osascriptTask] = osascriptTask
  osascriptTask:start()

  hs.console.darkMode(newMode)

  if wallpaper then
    local targetURL = hs.fs.urlFromPath(wallpaper)
    if targetURL then
      for _, screen in ipairs(hs.screen.allScreens()) do
        if screen:desktopImageURL() ~= targetURL then
          screen:desktopImageURL(targetURL)
        end
      end
    end
  end

  local themeLower = theme:lower()
  local replacements = {
    SIGNAL = signal,
    THEME = theme,
    THEME_LOWER = themeLower,
    PLUTIL_THEME = plutilTheme,
    BTOP_THEME = btopTheme,
  }
  local cmd = cmdTemplate:gsub("{{([%w_]+)}}", replacements)

  local zshTask
  zshTask = hs.task.new("/bin/zsh", function(exitCode, stdErr)
    if exitCode ~= 0 then
      hs.log
        .new("theme", "error")
        :e("Zsh theme task failed with exit code " .. tostring(exitCode) .. ": " .. tostring(stdErr))
    end
    activeTasks[zshTask] = nil
  end, { "-c", cmd })

  activeTasks[zshTask] = zshTask
  zshTask:start()
end)
