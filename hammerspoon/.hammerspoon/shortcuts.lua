hyper:bind({}, "a", function () hs.application.launchOrFocus("kitty") end)
hyper:bind({}, "c", function () hs.application.launchOrFocus("Calendar") end)
hyper:bind({}, "d", function () hs.application.launchOrFocus("Spotify") end)
hyper:bind({}, "e", function () hs.application.launchOrFocus("Mail") end)
hyper:bind({}, "f", function () hs.application.launchOrFocus("Finder") end)
hyper:bind({}, "g", function () hs.application.launchOrFocus("System Preferences") end)
hyper:bind({}, "q", function () hs.application.launchOrFocus("Skype") end)
hyper:bind({}, "r", function () hs.application.launchOrFocus("Notes") end)
hyper:bind({}, "s", function () hs.application.launchOrFocus("Safari") end)
hyper:bind({}, "t", function () hs.application.launchOrFocus("Calculator") end)
hyper:bind({}, "v", function () hs.application.launchOrFocus("Firefox") end)
hyper:bind({}, "w", function () hs.application.launchOrFocus("WhatsApp") end)
hyper:bind({}, "x", function () hs.application.launchOrFocus("Launchpad") end)
hyper:bind({}, "z", function () hs.application.launchOrFocus("Activity Monitor") end)

hyper:bind({"cmd"}, "f", function () hs.application.launchOrFocus("Google Chrome") end)
hyper:bind({"cmd"}, "g", function () hs.application.launchOrFocus("App Store") end)
hyper:bind({"cmd"}, "r", function () hs.application.launchOrFocus("Reminders") end)

-- Restart Hammerspoon
hyper:bind({"cmd", "shift"}, "r", function() hs.reload() end)

-- Create workspace
hyper:bind({"cmd"}, "1", function() hs.osascript.applescriptFromFile("monitor1.applescript") end)
hyper:bind({"cmd"}, "2", function() hs.osascript.applescriptFromFile("monitor2.applescript") end)
hyper:bind({"cmd"}, "3", function() hs.osascript.applescriptFromFile("monitor3.applescript") end)
