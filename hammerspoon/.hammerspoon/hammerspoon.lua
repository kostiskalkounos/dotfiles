local fnutils = require("hs.fnutils")
local screen = require("hs.screen")
local window = require("hs.window")

window.animationDuration = 0

hyper:bind({ "cmd" }, "h", function() window.focusedWindow():moveToUnit("[50,0,0,100]") end)
hyper:bind({ "cmd" }, "j", function() window.focusedWindow():moveToUnit("[0,50,100,100]") end)
hyper:bind({ "cmd" }, "k", function() window.focusedWindow():moveToUnit("[0,0,100,50]") end)
hyper:bind({ "cmd" }, "l", function() window.focusedWindow():moveToUnit("[50,100,100,0]") end)
hyper:bind({ "alt" }, "y", function() window.focusedWindow():moveToUnit("[33,0,0,100]") end)
hyper:bind({ "alt" }, "u", function() window.focusedWindow():moveToUnit("[0,65,100,100]") end)
hyper:bind({ "alt" }, "i", function() window.focusedWindow():moveToUnit("[0,0,100,35]") end)
hyper:bind({ "alt" }, "o", function() window.focusedWindow():moveToUnit("[67,100,100,0]") end)
hyper:bind({ "cmd" }, "y", function() window.focusedWindow():moveToUnit("[67,0,0,100]") end)
hyper:bind({ "cmd" }, "u", function() window.focusedWindow():moveToUnit("[0,35,100,100]") end)
hyper:bind({ "cmd" }, "i", function() window.focusedWindow():moveToUnit("[0,0,100,65]") end)
hyper:bind({ "cmd" }, "o", function() window.focusedWindow():moveToUnit("[33,100,100,0]") end)

hyper:bind({}, "Left", function() window.focusedWindow():moveToUnit("[0,0,50,50]") end)
hyper:bind({}, "Down", function() window.focusedWindow():moveToUnit("[0,50,50,100]") end)
hyper:bind({}, "Up", function() window.focusedWindow():moveToUnit("[50,0,100,50]") end)
hyper:bind({}, "Right", function() window.focusedWindow():moveToUnit("[50,50,100,100]") end)
hyper:bind({}, ";", function() window.focusedWindow():moveToUnit("[100,0,0,100]") end)
hyper:bind({}, "'", function() window.focusedWindow():moveToUnit("[100,0,0,100]") end)
hyper:bind({}, "p", function() window.focusedWindow():moveToUnit({ x = 0.125, y = 0.125, w = 0.75, h = 0.75 }) end)
hyper:bind({ "cmd" }, "p", function() window.focusedWindow():centerOnScreen() end)

hyper:bind({}, "h", function() window.filter.focusWest() end)
hyper:bind({}, "j", function() window.filter.focusSouth() end)
hyper:bind({}, "k", function() window.filter.focusNorth() end)
hyper:bind({}, "l", function() window.filter.focusEast() end)

hyper:bind({ "alt" }, "[", function()
  if window.focusedWindow():moveOneScreenWest() then
    window.focusedWindow():moveOneScreenWest()
  else
    window.focusedWindow():moveOneScreenEast()
  end
end)

hyper:bind({ "alt" }, "]", function()
  if window.focusedWindow():moveOneScreenEast() then
    window.focusedWindow():moveOneScreenEast()
  else
    window.focusedWindow():moveOneScreenWest()
  end
end)

local function moveWindowToDisplay(d)
  return function()
    local displays = screen.allScreens()
    local win = window.focusedWindow()
    win:moveToScreen(displays[d], false, true)
  end
end

hyper:bind({ "alt" }, "1", moveWindowToDisplay(1))
hyper:bind({ "alt" }, "2", moveWindowToDisplay(2))
hyper:bind({ "alt" }, "3", moveWindowToDisplay(3))

local function isInScreen(iScreen, win) return win:screen() == iScreen end

local function focusScreen(iScreen)
  local windows = fnutils.filter(window.orderedWindows(), fnutils.partial(isInScreen, iScreen))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()
  windowToFocus:focus()
end

hyper:bind({}, "[", function() focusScreen(window.focusedWindow():screen():previous()) end)
hyper:bind({}, "]", function() focusScreen(window.focusedWindow():screen():next()) end)
hyper:bind({}, "1", function() focusScreen(window.focusedWindow():screen():next()) end)
hyper:bind({}, "2", function() focusScreen(window.focusedWindow():screen():next()) end)
hyper:bind({}, "3", function() focusScreen(window.focusedWindow():screen():next()) end)

hyper:bind({}, "i", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - 10
  win:setFrame(f)
end)

hyper:bind({}, "y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

hyper:bind({}, "o", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  win:setFrame(f)
end)

hyper:bind({}, "u", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + 10
  win:setFrame(f)
end)
