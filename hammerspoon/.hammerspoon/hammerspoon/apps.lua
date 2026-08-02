local application = require("hs.application")

local function launchOrFocus(nameOrBundle)
  if not (nameOrBundle:match("%.") and application.launchOrFocusByBundleID(nameOrBundle)) then
    application.launchOrFocus(nameOrBundle)
  end
end

-- BundleID: osascript -e 'id of app "name"'
local appBindings = {
  {
    apps = {
      a = "net.kovidgoyal.kitty",
      c = "com.apple.iCal",
      d = "net.imput.helium",
      e = "com.apple.mail",
      f = "com.apple.finder",
      g = "com.apple.systempreferences",
      q = "com.jetbrains.intellij",
      r = "com.apple.Notes",
      s = "com.apple.Safari",
      t = "com.apple.calculator",
      v = "com.apple.reminders",
      w = "com.symphony.electron-desktop",
      x = "com.apple.AppStore",
      z = "com.apple.ActivityMonitor",
    },
  },
  {
    mods = { "cmd" },
    apps = {
      e = "com.mongodb.compass",
      w = "com.usebruno.app",
    },
  },
}

for _, binding in ipairs(appBindings) do
  local mods = binding.mods or {}
  for key, target in pairs(binding.apps) do
    Hyper:bind(mods, key, function()
      launchOrFocus(target)
    end)
  end
end
