local M = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function find_process(pid, except)
  local p = vim.api.nvim_get_proc(pid)
  if p and except[p.name] then
    return true
  end
  for _, child in ipairs(vim.api.nvim_get_proc_children(pid)) do
    if find_process(child, except) then
      return true
    end
  end
  return false
end

function M.smart_esc(term_pid)
  return t(find_process(term_pid, M.except) and M.key or "<C-\\><C-n>")
end

local function to_set(list)
  local ret = {}
  for _, v in ipairs(list) do
    ret[v] = true
  end
  return ret
end

function M.setup(cfg)
  M.key = (cfg and cfg.key) or "<Esc>"
  M.except = (cfg and cfg.except) and to_set(cfg.except) or { nvim = true }

  _G.termesc = M

  vim.api.nvim_set_keymap("t", M.key, "v:lua.termesc.smart_esc(b:terminal_job_pid)", { noremap = true, expr = true })
end

return M
