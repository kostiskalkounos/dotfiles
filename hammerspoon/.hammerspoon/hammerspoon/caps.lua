-- Remap caps to ctrl in settings before using

local sendEscape = false
local lastMods = {}

local function controlKeyHandler()
  sendEscape = false
end

local controlKeyTimer = hs.timer.delayed.new(0.3, controlKeyHandler)

local function controlHandler(evt)
  local newMods = evt:getFlags()
  if lastMods["ctrl"] == newMods["ctrl"] then
    return false
  end
  if not lastMods["ctrl"] then
    lastMods = newMods
    sendEscape = true
    controlKeyTimer:start()
  else
    lastMods = newMods
    controlKeyTimer:stop()
    if sendEscape then
      return true,
        {
          hs.eventtap.event.newKeyEvent({}, "escape", true),
          hs.eventtap.event.newKeyEvent({}, "escape", false),
        }
    end
  end
  return false
end

local controlTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, controlHandler)
controlTap:start()

return {
  controlKeyTimer = controlKeyTimer,
  controlHandler = controlHandler,
  controlTap = controlTap,
}
