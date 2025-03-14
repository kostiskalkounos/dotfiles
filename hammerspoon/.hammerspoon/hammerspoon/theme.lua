Hyper:bind({}, "/", function()
  local _, darkMode =
    hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')
  hs.osascript.applescript(
    ('tell app "System Events" to tell appearance preferences to set dark mode to %s'):format(
      darkMode and "false" or "true"
    )
  )
end)
