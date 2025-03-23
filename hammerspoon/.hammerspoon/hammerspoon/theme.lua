Hyper:bind({}, "/", function()
  local _, darkMode =
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')

  local lightWallpaper = "~/.hammerspoon/wallpapers/forest.jpg"
  local darkWallpaper = "~/.hammerspoon/wallpapers/catalina.jpg"

  if darkMode then
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to false')
    hs.osascript.applescript(
      ('tell app "System Events" to tell every desktop to set picture to "%s"'):format(lightWallpaper)
    )
  else
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to true')
    hs.osascript.applescript(
      ('tell app "System Events" to tell every desktop to set picture to "%s"'):format(darkWallpaper)
    )
  end
end)
