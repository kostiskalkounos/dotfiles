local fnutils = require("hs.fnutils")
local window = require("hs.window")

local function isInScreen(iScreen, win)
  return win:screen() == iScreen
end

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

local function resizeWindow(deltaX, deltaY)
  local win = hs.window.focusedWindow()
  if not win then return end

  local frame = win:frame()
  frame.w = frame.w + deltaX
  frame.h = frame.h + deltaY
  win:setFrame(frame)
end

local function moveWindow(deltaX, deltaY)
  local win = hs.window.focusedWindow()
  if not win then return end

  local frame = win:frame()
  frame.x = frame.x + deltaX
  frame.y = frame.y + deltaY
  win:setFrame(frame)
end

local function moveWindowToFixedSize(width, height)
  local win = hs.window.focusedWindow()
  if not win then return end

  local frame = win:screen():frame()

  local x = (frame.w - width) / 2 + frame.x
  local y = (frame.h - height) / 2 + frame.y

  win:setFrame({ x = x, y = y, w = width, h = height })
end

local function moveWindowToFraction(x1, y1, x2, y2, win)
  win = win or hs.window.focusedWindow()
  if not win then return end

  local screenFrame = win:screen():frame()

  local outerMargin = 3
  local innerMargin = outerMargin / 2

  local leftMargin = (x1 == 0) and outerMargin or innerMargin
  local rightMargin = (x2 == 1) and outerMargin or innerMargin
  local topMargin = (y1 == 0) and outerMargin or innerMargin
  local bottomMargin = (y2 == 1) and outerMargin or innerMargin

  local newFrame = hs.geometry.rect(
    screenFrame.x + (screenFrame.w * x1) + leftMargin,
    screenFrame.y + (screenFrame.h * y1) + topMargin,
    (screenFrame.w * (x2 - x1)) - (leftMargin + rightMargin),
    (screenFrame.h * (y2 - y1)) - (topMargin + bottomMargin)
  )

  win:setFrame(newFrame)
end

local function centerWindow()
  local win = hs.window.focusedWindow()
  if not win then return end

  local screenFrame = win:screen():frame()
  local winFrame = win:frame()

  local newX = screenFrame.x + (screenFrame.w - winFrame.w) / 2
  local newY = screenFrame.y + (screenFrame.h - winFrame.h) / 2

  win:setFrame(hs.geometry.rect(newX, newY, winFrame.w, winFrame.h))
end

local function maximizeWindows(x1, y1, x2, y2)
  local allWindows = hs.window.allWindows()
  local ignoredTitles = { "Calendar", "Finder", "Mail", "Notes", "Reminders", "Signal", "Spotify", "WhatsApp" }

  for _, win in ipairs(allWindows) do
    local app = win:application()
    if win:isStandard() and app and not hs.fnutils.contains(ignoredTitles, app:name()) then
      if (x1 and y1 and x2 and y2) then
        moveWindowToFraction(x1, y1, x2, y2, win)
      else
        win:maximize()
      end
    end
  end
end

Hyper:bind({}, "[", function() focusScreen(window.focusedWindow():screen():previous()) end)
Hyper:bind({}, "]", function() focusScreen(window.focusedWindow():screen():next()) end)

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

Hyper:bind({}, "h", function() window.filter.focusWest() end)
Hyper:bind({}, "j", function() window.filter.focusSouth() end)
Hyper:bind({}, "k", function() window.filter.focusNorth() end)
Hyper:bind({}, "l", function() window.filter.focusEast() end)

Hyper:bind({ "cmd" }, "p", centerWindow)
Hyper:bind({}, "p", function() moveWindowToFixedSize(1300, 810) end)

Hyper:bind({ "alt" }, "p", function() moveWindowToFraction(0.33, 0, 0.67, 1) end)
Hyper:bind({ "ctrl" }, "p", function() moveWindowToFraction(0, 0.33, 1, 0.67) end)
Hyper:bind({ "shift" }, "p", function() moveWindowToFraction(0, 0.33, 1, 0.67) end)

Hyper:bind({}, "'", function() moveWindowToFraction(0, 0, 1, 1) end)
Hyper:bind({}, ";", function() moveWindowToFraction(0, 0, 1, 1) end)
Hyper:bind({}, "/", function() window.focusedWindow():moveToUnit("[100,0,0,100]") end)

Hyper:bind({ "cmd" }, "'", function() maximizeWindows(0, 0, 1, 1) end)
Hyper:bind({ "cmd" }, ";", function() maximizeWindows(0, 0, 1, 1) end)
Hyper:bind({ "cmd" }, "/", function() maximizeWindows() end)

Hyper:bind({ "cmd" }, "h", function() moveWindowToFraction(0, 0, 0.5, 1) end)
Hyper:bind({ "cmd" }, "j", function() moveWindowToFraction(0, 0.5, 1, 1) end)
Hyper:bind({ "cmd" }, "k", function() moveWindowToFraction(0, 0, 1, 0.5) end)
Hyper:bind({ "cmd" }, "l", function() moveWindowToFraction(0.5, 0, 1, 1) end)

Hyper:bind({ "cmd" }, "y", function() moveWindowToFraction(0, 0, 0.67, 1) end)
Hyper:bind({ "cmd" }, "u", function() moveWindowToFraction(0, 0.33, 1, 1) end)
Hyper:bind({ "cmd" }, "i", function() moveWindowToFraction(0, 0, 1, 0.67) end)
Hyper:bind({ "cmd" }, "o", function() moveWindowToFraction(0.33, 0, 1, 1) end)

Hyper:bind({}, "Left", function() moveWindowToFraction(0, 0, 0.5, 0.5) end)
Hyper:bind({}, "Down", function() moveWindowToFraction(0, 0.5, 0.5, 1) end)
Hyper:bind({}, "Up", function() moveWindowToFraction(0.5, 0, 1, 0.5) end)
Hyper:bind({}, "Right", function() moveWindowToFraction(0.5, 0.5, 1, 1) end)

Hyper:bind({ "alt" }, "y", function() moveWindowToFraction(0, 0, 0.33, 1) end)
Hyper:bind({ "alt" }, "u", function() moveWindowToFraction(0, 0.67, 1, 1) end)
Hyper:bind({ "alt" }, "i", function() moveWindowToFraction(0, 0, 1, 0.33) end)
Hyper:bind({ "alt" }, "o", function() moveWindowToFraction(0.67, 0, 1, 1) end)

Hyper:bind({ "shift" }, "h", function() resizeWindow(-20, 0) end)
Hyper:bind({ "shift" }, "j", function() resizeWindow(0, 20) end)
Hyper:bind({ "shift" }, "k", function() resizeWindow(0, -20) end)
Hyper:bind({ "shift" }, "l", function() resizeWindow(20, 0) end)

Hyper:bind({ "ctrl" }, "h", function() moveWindow(-20, 0) end)
Hyper:bind({ "ctrl" }, "j", function() moveWindow(0, 20) end)
Hyper:bind({ "ctrl" }, "k", function() moveWindow(0, -20) end)
Hyper:bind({ "ctrl" }, "l", function() moveWindow(20, 0) end)
