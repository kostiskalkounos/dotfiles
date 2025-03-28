Hyper:bind({}, "/", function()
  local success, darkMode =
      hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')

  local lightWallpaper = "~/.hammerspoon/wallpapers/forest.jpg"
  local darkWallpaper = "~/.hammerspoon/wallpapers/catalina.jpg"
  local themeStateFile = "/tmp/theme_state"

  if not success then
    return
  end

  if darkMode then
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to false')
    hs.osascript.applescript(
      ('tell app "System Events" to tell every desktop to set picture to "%s"'):format(lightWallpaper)
    )
    hs.execute(string.format("echo 'light' > %s", themeStateFile), true)
  else
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to true')
    hs.osascript.applescript(
      ('tell app "System Events" to tell every desktop to set picture to "%s"'):format(darkWallpaper)
    )
    hs.execute(string.format("echo 'dark' > %s", themeStateFile), true)
  end

  hs.execute("tmux source-file ~/.tmux.conf", true)
  hs.execute("pkill -USR1 zsh", true)
end)
