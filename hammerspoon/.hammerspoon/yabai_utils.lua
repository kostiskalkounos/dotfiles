local m = {}

local function split(inputstr)
  local result = {}
  for word in inputstr:gmatch("%S+") do
    table.insert(result, word)
  end
  return result
end

local function slice(tbl, start)
  local sliced = {}
  for i = start or 1, #tbl do
    table.insert(sliced, tbl[i])
  end
  return sliced
end

local function taskExec(cmd)
  local parts = split(cmd)
  local path = parts[1]
  local args = slice(parts, 2)
  local tsStart = os.clock()
  print(string.format("EXECUTING COMMAND: %s", cmd))
  local taskIsDone = false
  local output
  if not coroutine.isyieldable() then
    error("this function cannot be invoked on the main Lua thread")
  end
  local task = hs.task.new(path, function(_, stdOut, _)
    output = stdOut
    taskIsDone = true
  end, args)
  task:start()
  while not taskIsDone do
    coroutine.yield() -- Yield to allow other coroutines to run
  end
  local tsEnd = os.clock()
  print(string.format("FINISHED COMMAND: (%.3f sec) %s", tsEnd - tsStart, cmd))
  return output
end

function m.execute(cmd)
  local fullCmd = string.format("/usr/local/bin/yabai -m %s", cmd)
  local co = coroutine.create(function()
    return taskExec(fullCmd)
  end)
  local success, result = coroutine.resume(co)
  if not success then
    print(result)
    return nil
  else
    return result
  end
end

-- function m.getWindows()
--     local windows = m.execute('query --windows')
--     return hs.json.decode(windows)
-- end
--
-- function m.focusWindow(windowId)
--     m.execute(string.format('window --focus %d', windowId))
-- end
--
-- function m.minimizeWindow(windowId)
--     m.execute(string.format('window %d --minimize', windowId))
-- end

return m

-- local function execute(args)
--   hs.task.new("/usr/local/bin/yabai", nil, function(_, ...)
--     print("stream", hs.inspect(table.pack(...)))
--     return true
--   end, args):start()
-- end
