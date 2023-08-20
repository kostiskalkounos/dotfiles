local fnutils = require("hs.fnutils")
local window = require("hs.window")

local function isInScreen(iScreen, win) return win:screen() == iScreen end

local function focusScreen(iScreen)
  local windows = fnutils.filter(window.orderedWindows(), fnutils.partial(isInScreen, iScreen))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()
  windowToFocus:focus()
end

local function moveWindowToDisplay(d)
  return function()
    local displays = hs.screen.allScreens()
    local win = window.focusedWindow()
    win:moveToScreen(displays[d], false, true)
  end
end

Hyper:bind({ "alt" }, "1", moveWindowToDisplay(1))
Hyper:bind({ "alt" }, "2", moveWindowToDisplay(2))
Hyper:bind({ "alt" }, "3", moveWindowToDisplay(3))

Hyper:bind({ "alt" }, "[", function()
  if window.focusedWindow():moveOneScreenWest() then
    window.focusedWindow():moveOneScreenWest()
  else
    window.focusedWindow():moveOneScreenEast()
  end
end)

Hyper:bind({ "alt" }, "]", function()
  if window.focusedWindow():moveOneScreenEast() then
    window.focusedWindow():moveOneScreenEast()
  else
    window.focusedWindow():moveOneScreenWest()
  end
end)

Hyper:bind({}, "[", function() focusScreen(window.focusedWindow():screen():previous()) end)
Hyper:bind({}, "]", function() focusScreen(window.focusedWindow():screen():next()) end)

-- Hyper:bind({}, "1", function() focusScreen(window.focusedWindow():screen():next()) end)
-- Hyper:bind({}, "2", function() focusScreen(window.focusedWindow():screen():next()) end)
-- Hyper:bind({}, "3", function() focusScreen(window.focusedWindow():screen():previous()) end)

-- Hyper:bind({ "cmd" }, "h", function() window.focusedWindow():moveToUnit("[50,0,0,100]") end)
-- Hyper:bind({ "cmd" }, "j", function() window.focusedWindow():moveToUnit("[0,50,100,100]") end)
-- Hyper:bind({ "cmd" }, "k", function() window.focusedWindow():moveToUnit("[0,0,100,50]") end)
-- Hyper:bind({ "cmd" }, "l", function() window.focusedWindow():moveToUnit("[50,100,100,0]") end)
-- Hyper:bind({ "alt" }, "y", function() window.focusedWindow():moveToUnit("[33,0,0,100]") end)
-- Hyper:bind({ "alt" }, "u", function() window.focusedWindow():moveToUnit("[0,65,100,100]") end)
-- Hyper:bind({ "alt" }, "i", function() window.focusedWindow():moveToUnit("[0,0,100,35]") end)
-- Hyper:bind({ "alt" }, "o", function() window.focusedWindow():moveToUnit("[67,100,100,0]") end)
-- Hyper:bind({ "cmd" }, "y", function() window.focusedWindow():moveToUnit("[67,0,0,100]") end)
-- Hyper:bind({ "cmd" }, "u", function() window.focusedWindow():moveToUnit("[0,35,100,100]") end)
-- Hyper:bind({ "cmd" }, "i", function() window.focusedWindow():moveToUnit("[0,0,100,65]") end)
-- Hyper:bind({ "cmd" }, "o", function() window.focusedWindow():moveToUnit("[33,100,100,0]") end)
--
-- Hyper:bind({}, "Left", function() window.focusedWindow():moveToUnit("[0,0,50,50]") end)
-- Hyper:bind({}, "Down", function() window.focusedWindow():moveToUnit("[0,50,50,100]") end)
-- Hyper:bind({}, "Up", function() window.focusedWindow():moveToUnit("[50,0,100,50]") end)
-- Hyper:bind({}, "Right", function() window.focusedWindow():moveToUnit("[50,50,100,100]") end)
-- Hyper:bind({}, ";", function() window.focusedWindow():moveToUnit("[100,0,0,100]") end)
-- Hyper:bind({}, "'", function() window.focusedWindow():moveToUnit("[100,0,0,100]") end)
-- Hyper:bind({}, "p", function() window.focusedWindow():moveToUnit({ x = 0.125, y = 0.125, w = 0.75, h = 0.75 }) end)
-- Hyper:bind({ "cmd" }, "p", function() window.focusedWindow():centerOnScreen() end)
--
-- Hyper:bind({}, "h", function() window.filter.focusWest() end)
-- Hyper:bind({}, "j", function() window.filter.focusSouth() end)
-- Hyper:bind({}, "k", function() window.filter.focusNorth() end)
-- Hyper:bind({}, "l", function() window.filter.focusEast() end)
--
-- Hyper:bind({}, "i", function()
--   local win = window.focusedWindow()
--   local f = win:frame()
--
--   f.y = f.y - 10
--   win:setFrame(f)
-- end)
--
-- Hyper:bind({}, "y", function()
--   local win = window.focusedWindow()
--   local f = win:frame()
--
--   f.x = f.x - 10
--   win:setFrame(f)
-- end)
--
-- Hyper:bind({}, "o", function()
--   local win = window.focusedWindow()
--   local f = win:frame()
--
--   f.x = f.x + 10
--   win:setFrame(f)
-- end)
--
-- Hyper:bind({}, "u", function()
--   local win = window.focusedWindow()
--   local f = win:frame()
--
--   f.y = f.y + 10
--   win:setFrame(f)
-- end)
