-- https://github.com/Hammerspoon/hammerspoon/issues/3698

local spaces = require("hs.spaces")

local function createSpace(d)
  local displays = hs.screen.allScreens()
  spaces.addSpaceToScreen(displays[d], true)
end

local function moveWindowToSpaceAndFocus(sp)
  local win = hs.window.focusedWindow()
  local cur_screen = hs.screen.mainScreen()
  local cur_screen_id = cur_screen:getUUID()
  local all_spaces = spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id][sp]

  spaces.moveWindowToSpace(win:id(), spaceID)
  spaces.gotoSpace(spaceID)
end

local function moveWindowToSpace(sp)
  local win = hs.window.focusedWindow()
  local cur_screen = hs.screen.mainScreen()
  local cur_screen_id = cur_screen:getUUID()
  local all_spaces = spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id][sp]

  spaces.moveWindowToSpace(win:id(), spaceID)
end

local function removeSpace(sp)
  local cur_screen = hs.screen.mainScreen()
  local cur_screen_id = cur_screen:getUUID()
  local all_spaces = spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id][sp]

  spaces.removeSpace(spaceID)
end

Hyper:bind({ "cmd" }, '1', function() moveWindowToSpaceAndFocus(1) end)
Hyper:bind({ "cmd" }, '2', function() moveWindowToSpaceAndFocus(2) end)
Hyper:bind({ "cmd" }, '3', function() moveWindowToSpaceAndFocus(3) end)
Hyper:bind({ "cmd" }, '4', function() moveWindowToSpaceAndFocus(4) end)
Hyper:bind({ "cmd" }, '5', function() moveWindowToSpaceAndFocus(5) end)
Hyper:bind({ "cmd" }, '6', function() moveWindowToSpaceAndFocus(6) end)
Hyper:bind({ "cmd" }, '7', function() moveWindowToSpaceAndFocus(7) end)
Hyper:bind({ "cmd" }, '8', function() moveWindowToSpaceAndFocus(8) end)
Hyper:bind({ "cmd" }, '9', function() moveWindowToSpaceAndFocus(9) end)
Hyper:bind({ "cmd" }, '0', function() moveWindowToSpaceAndFocus(0) end)

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

Hyper:bind({ "cmd", "alt" }, '1', function() removeSpace(1) end)
Hyper:bind({ "cmd", "alt" }, '2', function() removeSpace(2) end)
Hyper:bind({ "cmd", "alt" }, '3', function() removeSpace(3) end)
Hyper:bind({ "cmd", "alt" }, '4', function() removeSpace(4) end)
Hyper:bind({ "cmd", "alt" }, '5', function() removeSpace(5) end)
Hyper:bind({ "cmd", "alt" }, '6', function() removeSpace(6) end)
Hyper:bind({ "cmd", "alt" }, '7', function() removeSpace(7) end)
Hyper:bind({ "cmd", "alt" }, '8', function() removeSpace(8) end)
Hyper:bind({ "cmd", "alt" }, '9', function() removeSpace(9) end)
Hyper:bind({ "cmd", "alt" }, '0', function() removeSpace(0) end)

Hyper:bind({ "cmd", "shift" }, "1", function() createSpace(1) end)
Hyper:bind({ "cmd", "shift" }, "2", function() createSpace(2) end)
Hyper:bind({ "cmd", "shift" }, "3", function() createSpace(3) end)
