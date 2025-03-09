local hotkey = require("hs.hotkey")
local hyper = hotkey.modal.new({}, "F17")

local function pressed() hyper:enter() end
local function released() hyper:exit() end

hotkey.bind({}, 'F18', pressed, released)

return hyper
