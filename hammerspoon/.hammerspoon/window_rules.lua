local function isFullscreenApp(window)
  if not window then
    return false
  end
  local appName = window:application():name()

  local fullscreenApps = {
    "Brave Browser",
    "Firefox",
    "Safari",
    "kitty",
  }

  for _, fullscreenApp in ipairs(fullscreenApps) do
    if appName == fullscreenApp then
      return true
    end
  end
  return false
end

local function isApplicationFullscreen(appName)
  local windows = hs.window.filter.default:getWindows() -- Get all windows
  for _, win in ipairs(windows) do
    if win:application():name() == appName then
      local frame = win:frame()
      local screenFrame = win:screen():frame()

      local margin = 5
      if
        math.abs(frame.x - (screenFrame.x + margin)) < 1
        and math.abs(frame.y - (screenFrame.y + margin)) < 1
        and math.abs(frame.w - (screenFrame.w - 2 * margin)) < 1
        and math.abs(frame.h - (screenFrame.h - 2 * margin)) < 1
      then
        return true
      end
    end
  end
  return false
end

local function applyWindowRule(window)
  if not window then
    return
  end

  local appName = window:application():name()
  local defaultWindowSize = {
    x = 0.125,
    y = 0.125,
    w = 0.75,
    h = 0.75,
  }

  if isFullscreenApp(window) then
    if isApplicationFullscreen(appName) then
      local screenFrame = window:screen():frame()
      local adjustedFrame = hs.geometry.rect(
        screenFrame.x + (screenFrame.w * defaultWindowSize.x),
        screenFrame.y + (screenFrame.h * defaultWindowSize.y),
        screenFrame.w * defaultWindowSize.w,
        screenFrame.h * defaultWindowSize.h
      )
      window:setFrame(adjustedFrame)
    else
      local margin = 5
      local screenFrame = window:screen():frame()
      local adjustedFrame = hs.geometry.rect(
        screenFrame.x + margin,
        screenFrame.y + margin,
        screenFrame.w - (2 * margin),
        screenFrame.h - (2 * margin)
      )
      window:setFrame(adjustedFrame)
    end
  else
    local screenFrame = window:screen():frame()

    local adjustedFrame = hs.geometry.rect(
      screenFrame.x + (screenFrame.w * defaultWindowSize.x),
      screenFrame.y + (screenFrame.h * defaultWindowSize.y),
      screenFrame.w * defaultWindowSize.w,
      screenFrame.h * defaultWindowSize.h
    )
    window:setFrame(adjustedFrame)
  end
end

local allWindowsFilter = hs.window.filter.new()

allWindowsFilter:subscribe(hs.window.filter.windowCreated, function(window)
  hs.timer.doAfter(0.1, function()
    applyWindowRule(window)
  end)
end)

Hyper:bind({}, "b", function()
  local allWindows = hs.window.allWindows()
  for _, window in ipairs(allWindows) do
    applyWindowRule(window)
  end
end)
