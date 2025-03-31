local darkWallpaper, lightWallpaper
local scriptTemplate =
  'tell app "System Events"\n  tell appearance preferences to set dark mode to %s\n  tell every desktop to set picture to "%s"\nend tell'
local cmdTemplate = 'pkill -%s zsh; [ -n "$TMUX" ] && TMUX_THEME=%s tmux source-file ~/.tmux/%s.conf >/dev/null 2>&1 &'

Hyper:bind({}, "/", function()
  darkWallpaper = darkWallpaper or hs.fs.pathToAbsolute("~/.hammerspoon/wallpapers/catalina.jpg")
  lightWallpaper = lightWallpaper or hs.fs.pathToAbsolute("~/.hammerspoon/wallpapers/forest.jpg")

  local success, darkMode =
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')
  if not success then
    return
  end

  local newMode = not darkMode
  local theme = newMode and "Dark" or "Light"
  local wallpaper = newMode and darkWallpaper or lightWallpaper
  local signal = newMode and "USR1" or "USR2"

  hs.osascript._osascript(string.format(scriptTemplate, tostring(newMode), wallpaper), "AppleScript")
  hs.execute(string.format(cmdTemplate, signal, theme, theme), true)
end)
