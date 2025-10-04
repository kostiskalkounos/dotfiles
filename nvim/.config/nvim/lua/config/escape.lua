local M = {}

local api = vim.api
local set = vim.keymap.set

local replaceTermcodes = api.nvim_replace_termcodes
local defaultEscapeSequence = replaceTermcodes("<C-\\><C-n>", true, true, true)

local function transformKeySequence(sequence)
  return replaceTermcodes(sequence, true, true, true)
end

local function hasExcludedProcess(processId, excludedProcesses)
  local processInfo = api.nvim_get_proc(processId)
  if processInfo then
    if excludedProcesses[processInfo.name] then
      return true
    end
    local childProcessIds = api.nvim_get_proc_children(processId)
    for _, childProcessId in ipairs(childProcessIds) do
      if hasExcludedProcess(childProcessId, excludedProcesses) then
        return true
      end
    end
  end
  return false
end

function M.smartEscape(processId)
  return hasExcludedProcess(processId, M.excludedProcesses) and transformKeySequence(M.escapeKey)
    or defaultEscapeSequence
end

local function createExclusionSet(processNames)
  local exclusionSet = {}
  for _, processName in ipairs(processNames) do
    exclusionSet[processName] = true
  end
  return exclusionSet
end

function M.setup(config)
  M.escapeKey = config and config.key or "<Esc>"
  M.excludedProcesses = config and config.except and createExclusionSet(config.except) or { nvim = true }
  _G.termesc = M
  set("t", M.escapeKey, "v:lua.termesc.smartEscape(b:terminal_job_pid)", { noremap = true, expr = true })
end

return M
