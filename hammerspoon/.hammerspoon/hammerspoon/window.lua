local fnutils = require("hs.fnutils")
local geometry = require("hs.geometry")
local screen = require("hs.screen")
local window = require("hs.window")

local whitelist = {
  "Brave Browser",
  "Safari",
  "kitty",
}

local function isInScreen(iScreen, win)
  return win:screen() == iScreen
end

local function focusScreen(iScreen)
  local windows = fnutils.filter(window.orderedWindows(), fnutils.partial(isInScreen, iScreen))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()

  windowToFocus:focus()
end

local function moveWindowToDisplay(d)
  local displays = screen.allScreens()
  local win = window.focusedWindow()

  win:moveToScreen(displays[d], false, true)
end

local function resizeWindow(deltaX, deltaY)
  local win = window.focusedWindow()
  if not win then return end

  local frame = win:frame()
  frame.w = frame.w + deltaX
  frame.h = frame.h + deltaY

  win:setFrame(frame)
end

local function moveWindow(deltaX, deltaY)
  local win = window.focusedWindow()
  if not win then return end

  local frame = win:frame()
  frame.x = frame.x + deltaX
  frame.y = frame.y + deltaY

  win:setFrame(frame)
end

local function moveWindowToFixedSize(width, height)
  local win = window.focusedWindow()
  if not win then return end

  local frame = win:screen():frame()
  local x = (frame.w - width) / 2 + frame.x
  local y = (frame.h - height) / 2 + frame.y

  win:setFrame({ x = x, y = y, w = width, h = height })
end

local function moveWindowToFraction(x1, y1, x2, y2, win)
  win = win or window.focusedWindow()
  if not win then return end

  local outerMargin = 3
  local innerMargin = outerMargin / 2

  local leftMargin = (x1 == 0) and outerMargin or innerMargin
  local rightMargin = (x2 == 1) and outerMargin or innerMargin
  local topMargin = (y1 == 0) and outerMargin or innerMargin
  local bottomMargin = (y2 == 1) and outerMargin or innerMargin

  local screenFrame = win:screen():frame()
  local newFrame = geometry.rect(
    screenFrame.x + (screenFrame.w * x1) + leftMargin,
    screenFrame.y + (screenFrame.h * y1) + topMargin,
    (screenFrame.w * (x2 - x1)) - (leftMargin + rightMargin),
    (screenFrame.h * (y2 - y1)) - (topMargin + bottomMargin)
  )

  win:setFrame(newFrame)
end

local function centerWindow()
  local win = window.focusedWindow()
  if not win then return end

  local winFrame = win:frame()
  local screenFrame = win:screen():frame()

  local newX = screenFrame.x + (screenFrame.w - winFrame.w) / 2
  local newY = screenFrame.y + (screenFrame.h - winFrame.h) / 2

  win:setFrame(geometry.rect(newX, newY, winFrame.w, winFrame.h))
end

local function maximizeWindows(x1, y1, x2, y2)
  local allWindows = window.allWindows()

  for _, win in ipairs(allWindows) do
    local app = win:application()

    if win:isStandard() and app and fnutils.contains(whitelist, app:name()) then
      if (x1 and y1 and x2 and y2) then
        moveWindowToFraction(x1, y1, x2, y2, win)
      else
        win:maximize()
      end
    end
  end
end

local function focusWindowInDirection(direction)
  local win = window.focusedWindow()
  if not win then return end

  local allWindows = window.visibleWindows()
  local focusedScreen = win:screen()
  local candidateWindows = {}

  for _, w in ipairs(allWindows) do
    local appName = w:application():name()

    if fnutils.contains(whitelist, appName) and w:screen() == focusedScreen then
      table.insert(candidateWindows, w)
    end
  end

  local directionMethods = {
    east = "focusWindowEast",
    west = "focusWindowWest",
    north = "focusWindowNorth",
    south = "focusWindowSouth",
  }

  local method = directionMethods[direction]
  win[method](win, candidateWindows)
end

Hyper:bind({}, "[", function() focusScreen(window.focusedWindow():screen():previous()) end)
Hyper:bind({}, "]", function() focusScreen(window.focusedWindow():screen():next()) end)

Hyper:bind({ "alt" }, "1", function() moveWindowToDisplay(1) end)
Hyper:bind({ "alt" }, "2", function() moveWindowToDisplay(2) end)
Hyper:bind({ "alt" }, "3", function() moveWindowToDisplay(3) end)

Hyper:bind({ "alt" }, "[",
  function()
    if window.focusedWindow():moveOneScreenWest() then
      window.focusedWindow():moveOneScreenWest()
    else
      window
          .focusedWindow():moveOneScreenEast()
    end
  end)
Hyper:bind({ "alt" }, "]",
  function()
    if window.focusedWindow():moveOneScreenEast() then
      window.focusedWindow():moveOneScreenEast()
    else
      window
          .focusedWindow():moveOneScreenWest()
    end
  end)

Hyper:bind({}, "h", function() focusWindowInDirection("west") end)
Hyper:bind({}, "j", function() focusWindowInDirection("south") end)
Hyper:bind({}, "k", function() focusWindowInDirection("north") end)
Hyper:bind({}, "l", function() focusWindowInDirection("east") end)

Hyper:bind({ "cmd" }, "p", function() centerWindow() end)
Hyper:bind({}, "p", function() moveWindowToFixedSize(1300, 810) end)

Hyper:bind({ "alt" }, "p", function() moveWindowToFraction(0.33, 0, 0.67, 1) end)
Hyper:bind({ "ctrl" }, "p", function() moveWindowToFraction(0, 0.33, 1, 0.67) end)
Hyper:bind({ "shift" }, "p", function() moveWindowToFraction(0, 0.33, 1, 0.67) end)

Hyper:bind({}, "'", function() window.focusedWindow():moveToUnit("[100,0,0,100]") end)
Hyper:bind({}, ";", function() moveWindowToFraction(0, 0, 1, 1) end)

Hyper:bind({ "cmd" }, "'", function() maximizeWindows() end)
Hyper:bind({ "cmd" }, ";", function() maximizeWindows(0, 0, 1, 1) end)

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
