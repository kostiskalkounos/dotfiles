local application = require("hs.application")

local standardApps = {
  a = "kitty",
  c = "Calendar",
  d = "Helium",
  e = "Mail",
  f = "Finder",
  g = "System Settings",
  q = "IntelliJ IDEA",
  r = "Notes",
  s = "Safari",
  t = "Calculator",
  v = "Reminders",
  w = "Symphony",
  x = "App Store",
  z = "Activity Monitor",
}

for key, appName in pairs(standardApps) do
  Hyper:bind({}, key, function() application.launchOrFocus(appName) end)
end

Hyper:bind({ "cmd" }, "e", function() application.launchOrFocus("MongoDB Compass") end)
Hyper:bind({ "cmd" }, "w", function() application.launchOrFocus("Bruno") end)
