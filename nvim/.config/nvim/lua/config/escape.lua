local M = {}

local api = vim.api
local set = vim.keymap.set

local replaceTermcodes = api.nvim_replace_termcodes
local defaultEscapeSequence = replaceTermcodes("<C-\\><C-n>", true, true, true)

local function hasExcludedProcess(processId, excludedProcesses)
  if not processId or type(processId) ~= "number" or processId <= 0 then
    return false
  end
  local success, processInfo = pcall(api.nvim_get_proc, processId)
  if success and processInfo then
    if excludedProcesses[processInfo.name] then
      return true
    end
    local children_success, childProcessIds = pcall(api.nvim_get_proc_children, processId)
    if children_success and childProcessIds then
      for _, childProcessId in ipairs(childProcessIds) do
        if hasExcludedProcess(childProcessId, excludedProcesses) then
          return true
        end
      end
    end
  end
  return false
end

function M.smartEscape(processId)
  local now = vim.uv.now()
  local last_checked = vim.b.terminal_exclusion_last_checked or 0
  if vim.b.terminal_has_exclusion == nil or (now - last_checked) > 500 then
    vim.b.terminal_has_exclusion = hasExcludedProcess(processId, M.excludedProcesses)
    vim.b.terminal_exclusion_last_checked = now
  end
  return vim.b.terminal_has_exclusion and M.transformedEscapeKey or defaultEscapeSequence
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
  M.transformedEscapeKey = replaceTermcodes(M.escapeKey, true, true, true)
  M.excludedProcesses = config and config.except and createExclusionSet(config.except) or { nvim = true }
  set("t", M.escapeKey, function()
    return M.smartEscape(vim.b.terminal_job_pid)
  end, { noremap = true, expr = true })
end

return M
