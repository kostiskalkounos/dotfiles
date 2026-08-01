local hotkey = require("hs.hotkey")

Hyper = hotkey.modal.new()

local function pressed()
  Hyper:enter()
end
local function released()
  Hyper:exit()
end

hotkey.bind({}, "F18", pressed, released)

require("hammerspoon.apps")
require("hammerspoon.spaces")
require("hammerspoon.theme")
require("hammerspoon.window")
