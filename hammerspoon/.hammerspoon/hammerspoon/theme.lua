local darkWallpaper = hs.fs.pathToAbsolute("~/.hammerspoon/wallpapers/catalina.jpg")
local lightWallpaper = hs.fs.pathToAbsolute("~/.hammerspoon/wallpapers/forest.jpg")

local scriptTemplate = 'tell app "System Events" to tell appearance preferences to set dark mode to %s'

local cmdTemplate =
  'pkill -%s zsh; export NVIM_THEME=%s; [ -n "$TMUX" ] && tmux source-file ~/.tmux/%s.conf >/dev/null 2>&1 &'

Hyper:bind({}, "/", function()
  local darkMode = hs.settings.get("AppleInterfaceStyle") == "Dark"
  local newMode = not darkMode

  local theme = newMode and "Dark" or "Light"
  local wallpaper = newMode and darkWallpaper or lightWallpaper
  local signal = newMode and "USR1" or "USR2"

  hs.osascript.applescript(string.format(scriptTemplate, tostring(newMode)))

  hs.console.darkMode(newMode)

  if wallpaper then
    for _, screen in ipairs(hs.screen.allScreens()) do
      screen:desktopImageURL("file://" .. wallpaper)
    end
  end

  hs.execute(string.format(cmdTemplate, signal, theme, theme), true)
end)
