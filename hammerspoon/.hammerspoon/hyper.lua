local hyper = hs.hotkey.modal.new({}, nil)
local pressed = function() hyper:enter() end
local released = function() hyper:exit() end

hs.hotkey.bind({}, 'f19', pressed, released)

return hyper
