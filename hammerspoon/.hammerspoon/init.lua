-- Drag windows with cmd + ctrl + click
-- defaults write -g NSWindowShouldDragOnGesture -bool true
-- defaults write -g NSWindowShouldDragOnGestureFeedback -bool false

hs.console.darkMode(true)
hs.window.animationDuration = 0

Hyper = require("hyper")
require("hammerspoon")
require("keys")
require("window_rules")
