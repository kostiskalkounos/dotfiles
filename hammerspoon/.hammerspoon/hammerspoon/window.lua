local geometry = require("hs.geometry")
local screen = require("hs.screen")
local window = require("hs.window")

local allScreens = screen.allScreens
local desktop = window.desktop
local focusedWindow = window.focusedWindow
local mainScreen = screen.mainScreen
local orderedWindows = window.orderedWindows
local visibleWindows = window.visibleWindows

local whitelist = {
  ["Brave Browser"] = true,
  ["Helium"] = true,
  ["IntelliJ IDEA"] = true,
  ["Safari"] = true,
  ["kitty"] = true,
}

local function withFocused(fn)
  local win = focusedWindow()
  if win then
    return fn(win)
  end
end

local function focusScreen(iScreen)
  local windowToFocus = desktop()
  for _, win in ipairs(orderedWindows()) do
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
  local displays = allScreens()
  if not displays[d] then
    return
  end
  focusScreen(displays[d])
end

local function moveWindowScreenWestWithWrap(win)
  local screenBefore = win:screen()
  win:moveOneScreenWest(false, true)
  if win:screen() == screenBefore then
    win:moveOneScreenEast(false, true)
  end
end

local function moveWindowScreenEastWithWrap(win)
  local screenBefore = win:screen()
  win:moveOneScreenEast(false, true)
  if win:screen() == screenBefore then
    win:moveOneScreenWest(false, true)
  end
end

local function moveWindowToFixedSize(width, height, win)
  win = win or focusedWindow()
  if not win then
    return
  end
  local frame = win:screen():frame()
  local x = (frame.w - width) / 2 + frame.x
  local y = (frame.h - height) / 2 + frame.y

  win:setFrame({ x = x, y = y, w = width, h = height })
end

local function moveWindowToFraction(x1, y1, x2, y2, win)
  win = win or focusedWindow()
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

local function centerWindow(win)
  win:centerOnScreen(nil, true)
end

local function makeResizer(deltaX, deltaY)
  return function(win)
    local frame = win:frame()
    frame.w = frame.w + deltaX
    frame.h = frame.h + deltaY

    win:setFrame(frame)
  end
end

local function makeMover(deltaX, deltaY)
  return function(win)
    local frame = win:frame()
    frame.x = frame.x + deltaX
    frame.y = frame.y + deltaY

    win:setFrame(frame)
  end
end

local function makeMaximizer(x1, y1, x2, y2)
  return function()
    local activeScreen = mainScreen()

    for _, win in ipairs(visibleWindows()) do
      local app = win:application()
      local appName = app and app:title()

      if appName and whitelist[appName] and win:isStandard() and win:screen() == activeScreen then
        if x1 and y1 and x2 and y2 then
          moveWindowToFraction(x1, y1, x2, y2, win)
        else
          win:maximize()
        end
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

local function makeDirectionFocuser(direction)
  return function()
    local win = focusedWindow()
    if not win then
      return
    end
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
  end
end

local function focusPreviousScreen(win)
  focusScreen(win:screen():previous())
end

local function focusNextScreen(win)
  focusScreen(win:screen():next())
end

local function makeDisplayMover(d)
  return function()
    local win = focusedWindow()
    if not win then
      return
    end
    local displays = allScreens()
    if not displays[d] then
      return
    end
    win:moveToScreen(displays[d], false, true)
  end
end

local function makeScreenFocuser(d)
  return function()
    focusScreenByIndex(d)
  end
end

local function maximizeToUnit(win)
  win:moveToUnit("[0,0,100,100]")
end

local function makeFractionMover(x1, y1, x2, y2)
  return function()
    moveWindowToFraction(x1, y1, x2, y2)
  end
end

local function makeFixedSizeMover(width, height)
  return function()
    moveWindowToFixedSize(width, height)
  end
end

Hyper:bind({}, "[", function()
  withFocused(focusPreviousScreen)
end)

Hyper:bind({}, "]", function()
  withFocused(focusNextScreen)
end)

Hyper:bind({ "alt" }, "[", function()
  withFocused(moveWindowScreenWestWithWrap)
end)
Hyper:bind({ "alt" }, "]", function()
  withFocused(moveWindowScreenEastWithWrap)
end)

Hyper:bind({ "cmd" }, "[", function()
  withFocused(moveWindowScreenWestWithWrap)
end)
Hyper:bind({ "cmd" }, "]", function()
  withFocused(moveWindowScreenEastWithWrap)
end)

Hyper:bind({}, ";", makeFractionMover(0, 0, 1, 1))
Hyper:bind({}, "'", function()
  withFocused(maximizeToUnit)
end)

Hyper:bind({}, "h", makeDirectionFocuser("west"))
Hyper:bind({}, "j", makeDirectionFocuser("south"))
Hyper:bind({}, "k", makeDirectionFocuser("north"))
Hyper:bind({}, "l", makeDirectionFocuser("east"))

Hyper:bind({ "cmd" }, "p", function()
  withFocused(centerWindow)
end)
Hyper:bind({}, "p", makeFixedSizeMover(1300, 810))

Hyper:bind({ "alt" }, "p", makeFractionMover(0.33, 0, 0.67, 1))
Hyper:bind({ "ctrl" }, "p", makeFractionMover(0, 0.33, 1, 0.67))

Hyper:bind({ "cmd" }, "'", makeMaximizer())
Hyper:bind({ "cmd" }, ";", makeMaximizer(0, 0, 1, 1))

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
  Hyper:bind(
    layout.modifiers,
    layout.key,
    makeFractionMover(layout.rect[1], layout.rect[2], layout.rect[3], layout.rect[4])
  )
end

-- Resizing (yuio keys)
local resizeDirections = {
  y = { -20, 0 },
  u = { 0, 20 },
  i = { 0, -20 },
  o = { 20, 0 },
}
for key, delta in pairs(resizeDirections) do
  local resizer = makeResizer(delta[1], delta[2])
  Hyper:bind({}, key, function()
    withFocused(resizer)
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
  local mover = makeMover(delta[1], delta[2])
  Hyper:bind({ "ctrl" }, key, function()
    withFocused(mover)
  end)
end

for i = 1, 3 do
  local numStr = tostring(i)
  Hyper:bind({ "cmd" }, numStr, makeDisplayMover(i))
  Hyper:bind({}, numStr, makeScreenFocuser(i))
end
