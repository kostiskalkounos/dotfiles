local darkWallpaper = hs.fs.pathToAbsolute("~/.hammerspoon/wallpapers/catalina.jpg")
local lightWallpaper = hs.fs.pathToAbsolute("~/.hammerspoon/wallpapers/forest.jpg")

local scriptTemplate =
  'tell app "System Events"\n  tell appearance preferences to set dark mode to %s\n  tell every desktop to set picture to "%s"\nend tell'

local script = "~/.hammerspoon/scripts/theme.sh %s"

Hyper:bind({}, "/", function()
  local success, darkMode =
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')
  if not success then
    return
  end

  local newMode = not darkMode
  local theme = newMode and "dark" or "light"
  local wallpaper = newMode and darkWallpaper or lightWallpaper

  hs.osascript._osascript(string.format(scriptTemplate, tostring(newMode), wallpaper), "AppleScript")

  hs.execute(string.format(script, theme), true)
end)
