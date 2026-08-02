local geometry = require("hs.geometry")
local screen = require("hs.screen")
local window = require("hs.window")

local whitelist = {
  ["Brave Browser"] = true,
  ["Helium"] = true,
  ["IntelliJ IDEA"] = true,
  ["Safari"] = true,
  ["kitty"] = true,
}

local function withFocused(fn)
  local win = window.focusedWindow()
  if win then
    return fn(win)
  end
end

local function focusScreen(iScreen)
  local windowToFocus = window.desktop()
  for _, win in ipairs(window.orderedWindows()) do
    if win:screen() == iScreen then
      windowToFocus = win
      break
    end
  end
  if windowToFocus then
    windowToFocus:focus()
  end
end

local function focusScreenByIndex(d)
  local displays = screen.allScreens()
  if not displays[d] then
    return
  end
  focusScreen(displays[d])
end

local function moveWindowToDisplay(d)
  withFocused(function(win)
    local displays = screen.allScreens()
    if not displays[d] then
      return
    end
    win:moveToScreen(displays[d], false, true)
  end)
end

local function resizeWindow(deltaX, deltaY)
  withFocused(function(win)
    local frame = win:frame()
    frame.w = frame.w + deltaX
    frame.h = frame.h + deltaY

    win:setFrame(frame)
  end)
end

local function moveWindow(deltaX, deltaY)
  withFocused(function(win)
    local frame = win:frame()
    frame.x = frame.x + deltaX
    frame.y = frame.y + deltaY

    win:setFrame(frame)
  end)
end

local function moveWindowToFixedSize(width, height)
  withFocused(function(win)
    local frame = win:screen():frame()
    local x = (frame.w - width) / 2 + frame.x
    local y = (frame.h - height) / 2 + frame.y

    win:setFrame({ x = x, y = y, w = width, h = height })
  end)
end

local function moveWindowToFraction(x1, y1, x2, y2, win)
  win = win or window.focusedWindow()
  if not win then
    return
  end

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
  withFocused(function(win)
    local winFrame = win:frame()
    local screenFrame = win:screen():frame()

    local newX = screenFrame.x + (screenFrame.w - winFrame.w) / 2
    local newY = screenFrame.y + (screenFrame.h - winFrame.h) / 2

    win:setFrame(geometry.rect(newX, newY, winFrame.w, winFrame.h))
  end)
end

local function maximizeWindows(x1, y1, x2, y2)
  local activeScreen = screen.mainScreen()

  for _, win in ipairs(window.visibleWindows()) do
    local app = win:application()
    local appName = app and app:title()

    if appName and whitelist[appName] and win:isStandard() and win:screen() == activeScreen then
      if x1 and y1 and x2 and y2 then
        moveWindowToFraction(x1, y1, x2, y2, win)
      else
        win:maximize(0)
      end
    end
  end
end

local directionMethods = {
  east = "focusWindowEast",
  west = "focusWindowWest",
  north = "focusWindowNorth",
  south = "focusWindowSouth",
}

local function focusWindowInDirection(direction)
  withFocused(function(win)
    local candidateWindows = {}

    for _, w in ipairs(win:otherWindowsSameScreen()) do
      local app = w:application()
      local appName = app and app:title()

      if appName and whitelist[appName] then
        table.insert(candidateWindows, w)
      end
    end

    local method = directionMethods[direction]
    win[method](win, candidateWindows)
  end)
end

Hyper:bind({}, "[", function()
  withFocused(function(win)
    focusScreen(win:screen():previous())
  end)
end)

Hyper:bind({}, "]", function()
  withFocused(function(win)
    focusScreen(win:screen():next())
  end)
end)

for i = 1, 3 do
  local numStr = tostring(i)
  Hyper:bind({ "cmd" }, numStr, function()
    moveWindowToDisplay(i)
  end)
  Hyper:bind({}, numStr, function()
    focusScreenByIndex(i)
  end)
end

Hyper:bind({ "cmd" }, "[", function()
  withFocused(function(win)
    local screenBefore = win:screen()
    win:moveOneScreenWest(false, true)
    if win:screen() == screenBefore then
      win:moveOneScreenEast(false, true)
    end
  end)
end)

Hyper:bind({ "cmd" }, "]", function()
  withFocused(function(win)
    local screenBefore = win:screen()
    win:moveOneScreenEast(false, true)
    if win:screen() == screenBefore then
      win:moveOneScreenWest(false, true)
    end
  end)
end)

Hyper:bind({}, ";", function()
  moveWindowToFraction(0, 0, 1, 1)
end)
Hyper:bind({}, "'", function()
  withFocused(function(win)
    win:moveToUnit("[0,0,100,100]")
  end)
end)

Hyper:bind({}, "h", function()
  focusWindowInDirection("west")
end)
Hyper:bind({}, "j", function()
  focusWindowInDirection("south")
end)
Hyper:bind({}, "k", function()
  focusWindowInDirection("north")
end)
Hyper:bind({}, "l", function()
  focusWindowInDirection("east")
end)

Hyper:bind({ "cmd" }, "p", function()
  centerWindow()
end)
Hyper:bind({}, "p", function()
  moveWindowToFixedSize(1300, 810)
end)

Hyper:bind({ "alt" }, "p", function()
  moveWindowToFraction(0.33, 0, 0.67, 1)
end)
Hyper:bind({ "ctrl" }, "p", function()
  moveWindowToFraction(0, 0.33, 1, 0.67)
end)

Hyper:bind({ "cmd" }, "'", function()
  maximizeWindows()
end)
Hyper:bind({ "cmd" }, ";", function()
  maximizeWindows(0, 0, 1, 1)
end)

local fractionalLayouts = {
  -- Half Screen (cmd + hjkl)
  { modifiers = { "cmd" }, key = "h", rect = { 0, 0, 0.5, 1 } },
  { modifiers = { "cmd" }, key = "j", rect = { 0, 0.5, 1, 1 } },
  { modifiers = { "cmd" }, key = "k", rect = { 0, 0, 1, 0.5 } },
  { modifiers = { "cmd" }, key = "l", rect = { 0.5, 0, 1, 1 } },

  -- Two-Thirds Screen (cmd + yuio)
  { modifiers = { "cmd" }, key = "y", rect = { 0, 0, 0.67, 1 } },
  { modifiers = { "cmd" }, key = "u", rect = { 0, 0.33, 1, 1 } },
  { modifiers = { "cmd" }, key = "i", rect = { 0, 0, 1, 0.67 } },
  { modifiers = { "cmd" }, key = "o", rect = { 0.33, 0, 1, 1 } },

  -- One-Third Screen (alt + yuio)
  { modifiers = { "alt" }, key = "y", rect = { 0, 0, 0.33, 1 } },
  { modifiers = { "alt" }, key = "u", rect = { 0, 0.67, 1, 1 } },
  { modifiers = { "alt" }, key = "i", rect = { 0, 0, 1, 0.33 } },
  { modifiers = { "alt" }, key = "o", rect = { 0.67, 0, 1, 1 } },

  -- Quadrants (arrow keys)
  { modifiers = {}, key = "Left", rect = { 0, 0, 0.5, 0.5 } },
  { modifiers = {}, key = "Down", rect = { 0, 0.5, 0.5, 1 } },
  { modifiers = {}, key = "Up", rect = { 0.5, 0, 1, 0.5 } },
  { modifiers = {}, key = "Right", rect = { 0.5, 0.5, 1, 1 } },
}

for _, layout in ipairs(fractionalLayouts) do
  Hyper:bind(layout.modifiers, layout.key, function()
    moveWindowToFraction(layout.rect[1], layout.rect[2], layout.rect[3], layout.rect[4])
  end)
end

-- Resizing (yuio keys)
local resizeDirections = {
  y = { -20, 0 },
  u = { 0, 20 },
  i = { 0, -20 },
  o = { 20, 0 },
}
for key, delta in pairs(resizeDirections) do
  Hyper:bind({}, key, function()
    resizeWindow(delta[1], delta[2])
  end)
end

-- Moving (ctrl + hjkl)
local moveDirections = {
  h = { -20, 0 },
  j = { 0, 20 },
  k = { 0, -20 },
  l = { 20, 0 },
}
for key, delta in pairs(moveDirections) do
  Hyper:bind({ "ctrl" }, key, function()
    moveWindow(delta[1], delta[2])
  end)
end
