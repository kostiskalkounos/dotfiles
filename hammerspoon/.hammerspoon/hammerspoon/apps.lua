local application = require("hs.application")

local standardApps = {
  a = "kitty",
  c = "Calendar",
  d = "Helium",
  e = "Mail",
  f = "Finder",
  g = "System Settings",
  q = "Signal",
  r = "Notes",
  s = "Safari",
  t = "Calculator",
  v = "Reminders",
  w = "WhatsApp",
  x = "App Store",
  z = "Activity Monitor",
}

for key, appName in pairs(standardApps) do
  Hyper:bind({}, key, function()
    application.launchOrFocus(appName)
  end)
end
