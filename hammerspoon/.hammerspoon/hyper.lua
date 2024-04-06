local hyper = hs.hotkey.modal.new({}, "F17")
local pressed = function() hyper:enter() end
local released = function() hyper:exit() end

hs.hotkey.bind({}, 'F18', pressed, released)

return hyper
