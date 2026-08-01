-- https://github.com/Hammerspoon/hammerspoon/issues/3698

local screen = require("hs.screen")
local spaces = require("hs.spaces")
local window = require("hs.window")

local function addSpaceToScreen(screenIdx)
  local displays = screen.allScreens()
  if displays[screenIdx] then
    spaces.addSpaceToScreen(displays[screenIdx], true)
  end
end

local function removeSpace(sp)
  local cur_screen = screen.mainScreen()
  if not cur_screen then
    return
  end

  local cur_screen_id = cur_screen:getUUID()
  local all_spaces = spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id] and all_spaces[cur_screen_id][sp]

  if not spaceID then
    return
  end

  spaces.removeSpace(spaceID)
end

local function moveWindowToSpace(sp)
  local win = window.focusedWindow()

  if not win then
    return
  end

  local cur_screen = win:screen()
  local cur_screen_id = cur_screen:getUUID()
  local all_spaces = spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id] and all_spaces[cur_screen_id][sp]

  if not spaceID then
    return
  end

  spaces.moveWindowToSpace(win:id(), spaceID)
  spaces.gotoSpace(spaceID)
end

for i = 1, 3 do
  Hyper:bind({ "cmd" }, tostring(i), function()
    addSpaceToScreen(i)
  end)
end

for i = 1, 9 do
  local str_i = tostring(i)
  Hyper:bind({ "shift" }, str_i, function()
    removeSpace(i)
  end)

  Hyper:bind({ "cmd", "ctrl" }, str_i, function()
    moveWindowToSpace(i)
  end)
end

Hyper:bind({ "shift" }, "0", function()
  removeSpace(10)
end)

Hyper:bind({ "cmd", "ctrl" }, "0", function()
  moveWindowToSpace(10)
end)
