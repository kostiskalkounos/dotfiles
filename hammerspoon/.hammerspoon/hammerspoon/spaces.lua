-- https://github.com/Hammerspoon/hammerspoon/issues/3698

local screen = require("hs.screen")
local spaces = require("hs.spaces")
local window = require("hs.window")

local function createSpace(sp)
  local displays = screen.allScreens()
  spaces.addSpaceToScreen(displays[sp], true)
end

local function removeSpace(sp)
  local cur_screen = screen.mainScreen()
  local cur_screen_id = cur_screen:getUUID()
  local all_spaces = spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id][sp]
  if not spaceID then return end
  spaces.removeSpace(spaceID)
end

local function moveWindowToSpace(sp)
  local win = window.focusedWindow()
  local cur_screen = screen.mainScreen()
  local cur_screen_id = cur_screen:getUUID()
  local all_spaces = spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id][sp]
  if not spaceID then return end
  spaces.moveWindowToSpace(win:id(), spaceID)
  spaces.gotoSpace(spaceID)
end

Hyper:bind({ "cmd" }, "1", function() createSpace(1) end)
Hyper:bind({ "cmd" }, "2", function() createSpace(2) end)
Hyper:bind({ "cmd" }, "3", function() createSpace(3) end)

Hyper:bind({ "shift" }, '1', function() removeSpace(1) end)
Hyper:bind({ "shift" }, '2', function() removeSpace(2) end)
Hyper:bind({ "shift" }, '3', function() removeSpace(3) end)
Hyper:bind({ "shift" }, '4', function() removeSpace(4) end)
Hyper:bind({ "shift" }, '5', function() removeSpace(5) end)
Hyper:bind({ "shift" }, '6', function() removeSpace(6) end)
Hyper:bind({ "shift" }, '7', function() removeSpace(7) end)
Hyper:bind({ "shift" }, '8', function() removeSpace(8) end)
Hyper:bind({ "shift" }, '9', function() removeSpace(9) end)
Hyper:bind({ "shift" }, '0', function() removeSpace(0) end)

Hyper:bind({ "cmd", "ctrl" }, '1', function() moveWindowToSpace(1) end)
Hyper:bind({ "cmd", "ctrl" }, '2', function() moveWindowToSpace(2) end)
Hyper:bind({ "cmd", "ctrl" }, '3', function() moveWindowToSpace(3) end)
Hyper:bind({ "cmd", "ctrl" }, '4', function() moveWindowToSpace(4) end)
Hyper:bind({ "cmd", "ctrl" }, '5', function() moveWindowToSpace(5) end)
Hyper:bind({ "cmd", "ctrl" }, '6', function() moveWindowToSpace(6) end)
Hyper:bind({ "cmd", "ctrl" }, '7', function() moveWindowToSpace(7) end)
Hyper:bind({ "cmd", "ctrl" }, '8', function() moveWindowToSpace(8) end)
Hyper:bind({ "cmd", "ctrl" }, '9', function() moveWindowToSpace(9) end)
Hyper:bind({ "cmd", "ctrl" }, '0', function() moveWindowToSpace(0) end)
