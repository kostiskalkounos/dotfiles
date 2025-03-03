local hyper = hs.hotkey.modal.new({}, "F17")

local function pressed() hyper:enter() end
local function released() hyper:exit() end

hs.hotkey.bind({}, 'F18', pressed, released)

return hyper
