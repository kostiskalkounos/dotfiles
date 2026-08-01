local logger = hs.logger.new("theme", "info")

local unpack = table.unpack or unpack

local function normalizeURL(url)
  if type(url) ~= "string" then
    return nil
  end
  return (url:gsub("^file://localhost", "file://"))
end

local THEME_CONFIGS = {
  [true] = {
    name = "Dark",
    signal = "USR1",
    plutil = "Default",
    btop = "tokyo-storm",
    wallpaper = normalizeURL(hs.fs.urlFromPath(hs.configdir .. "/wallpapers/catalina.jpg")),
  },
  [false] = {
    name = "Light",
    signal = "USR2",
    plutil = "Default Light",
    btop = "kanagawa-lotus",
    wallpaper = normalizeURL(hs.fs.urlFromPath(hs.configdir .. "/wallpapers/forest.jpg")),
  },
}

local function isSystemDark()
  return hs.host.interfaceStyle() == "Dark"
end

local currentThemeIsDark = isSystemDark()

hs.console.darkMode(currentThemeIsDark)
if hs.preferencesDarkMode then
  hs.preferencesDarkMode(currentThemeIsDark)
end

local function syncWallpapers(targetURL)
  local normalizedTarget = normalizeURL(targetURL) or THEME_CONFIGS[currentThemeIsDark].wallpaper

  if not normalizedTarget then
    return
  end

  for _, s in ipairs(hs.screen.allScreens()) do
    pcall(function()
      if normalizeURL(s:desktopImageURL()) ~= normalizedTarget then
        s:desktopImageURL(normalizedTarget)
      end
    end)
  end
end

syncWallpapers()

local activeTasks = {}
local cmdTemplate = [=[
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

mkdir -p $HOME/.cache/zsh
echo "{{THEME_LOWER}}" > $HOME/.cache/zsh/theme

{{RUN_OSASCRIPT}}

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

{
  for s in $HOME/.cache/nvim/sockets/nvim-*.sock(N); do
    if [ -S "$s" ]; then
      filename=${s##*/}
      pid=${filename#nvim-}
      pid=${pid%.sock}
      if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        nvim --headless -u NONE -i NONE --server "$s" --remote-expr "luaeval('pcall(function() vim.o.background=\"{{THEME_LOWER}}\" end)', '')" >/dev/null 2>&1 < /dev/null &!
      else
        rm "$s"
      fi
    fi
  done
} >/dev/null 2>&1 < /dev/null &!

pgrep tmux >/dev/null && {
  [ -f "$HOME/.tmux/{{THEME_LOWER}}.conf" ] && tmux source-file "$HOME/.tmux/{{THEME_LOWER}}.conf"
  tmux list-clients -F '#{client_name}' 2>/dev/null | xargs -I {} tmux refresh-client -t '{}'
} >/dev/null 2>&1 < /dev/null &!

# Update all config files concurrently to achieve 100% simultaneous transition speeds
{
  [ -f $HOME/.gemini/settings.json ] && {
    plutil -replace ui.theme -string "{{PLUTIL_THEME}}" $HOME/.gemini/settings.json >/dev/null 2>&1 && plutil -convert json -r $HOME/.gemini/settings.json >/dev/null 2>&1
  } &

  {
    for dir in "$HOME/.config/k9s" "$HOME/Library/Application Support/k9s"; do
      [ -d "$dir/skins" ] && {
        cp -f "$dir/skins/{{THEME_LOWER}}.yaml" "$dir/skins/current.yaml"
        touch "$dir/config.yaml" 2>/dev/null
      }
    done
  } &

  [ -f $HOME/.config/btop/btop.conf ] && {
    sed -i '' \
      -e 's/^color_theme = .*/color_theme = "{{BTOP_THEME}}"/' \
      -e 's/^theme_background = .*/theme_background = False/' \
      -e 's/^vim_keys = .*/vim_keys = True/' \
      $HOME/.config/btop/btop.conf && pkill -USR2 -x btop
  } &

  [ -f $HOME/.config/kitty/kitty.conf ] && {
    cp -f $HOME/.config/kitty/{{THEME_LOWER}}-theme.auto.conf $HOME/.config/kitty/current-theme.conf && pkill -USR1 -x kitty
  } &

  wait
} >/dev/null 2>&1 < /dev/null
]=]

local function applyTheme(isDark)
  local actualDark = isSystemDark()
  if currentThemeIsDark == isDark and actualDark == isDark then
    return
  end

  currentThemeIsDark = isDark

  local cfg = THEME_CONFIGS[isDark]
  hs.console.darkMode(isDark)
  if hs.preferencesDarkMode then
    hs.preferencesDarkMode(isDark)
  end
  syncWallpapers()

  local runOsascript = actualDark ~= isDark
      and string.format(
        "osascript -e 'tell app \"System Events\" to tell appearance preferences to set dark mode to %s' >/dev/null 2>&1 < /dev/null &!",
        tostring(isDark)
      )
    or ""

  local cmd = cmdTemplate:gsub("{{([%w_]+)}}", {
    BTOP_THEME = cfg.btop,
    RUN_OSASCRIPT = runOsascript,
    PLUTIL_THEME = cfg.plutil,
    SIGNAL = cfg.signal,
    THEME_LOWER = cfg.name:lower(),
  })

  local zshTask
  zshTask = hs.task.new("/bin/zsh", function(exitCode, _, stdErr)
    activeTasks[zshTask] = nil
    if exitCode ~= 0 then
      logger.ef("Theme transition task failed with code %d: %s", exitCode, stdErr or "")
    end
  end, { "-c", cmd })

  activeTasks[zshTask] = true

  local ok, success = pcall(function()
    return zshTask:start()
  end)
  if not (ok and success) then
    activeTasks[zshTask] = nil
    currentThemeIsDark = isSystemDark()
    logger.ef("Failed to initiate theme transition shell process.")
  end
end

Hyper:bind({}, "/", function()
  applyTheme(not currentThemeIsDark)
end)

local function debounce(delay, fn)
  local t = nil
  return function(...)
    local args = { ... }
    local n = select("#", ...)
    if t then
      t:stop()
    end
    t = hs.timer.doAfter(delay, function()
      t = nil
      fn(unpack(args, 1, n))
    end)
  end
end

activeTasks.spaceWatcher = hs.spaces.watcher.new(debounce(0.15, syncWallpapers))
activeTasks.spaceWatcher:start()

activeTasks.screenWatcher = hs.screen.watcher.new(debounce(0.5, syncWallpapers))
activeTasks.screenWatcher:start()

activeTasks.themeWatcher = hs.distributednotifications.new(function()
  applyTheme(isSystemDark())
end, "AppleInterfaceThemeChangedNotification")
activeTasks.themeWatcher:start()

activeTasks.caffeinateWatcher = hs.caffeinate.watcher.new(function(event)
  if event == hs.caffeinate.watcher.systemDidWake then
    applyTheme(isSystemDark())
    syncWallpapers()
  end
end)
activeTasks.caffeinateWatcher:start()

hs.shutdownCallback = function()
  for k, v in pairs(activeTasks) do
    if type(k) == "userdata" then
      pcall(function()
        local method = k["terminate"]
        if type(method) == "function" then
          method(k)
        end
      end)
    end
    if type(v) == "userdata" then
      pcall(function()
        local method = v["stop"]
        if type(method) == "function" then
          method(v)
        end
      end)
    end
  end
end

_G.themeTasks = activeTasks
