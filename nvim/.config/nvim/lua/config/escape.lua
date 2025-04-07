local M = {}
local a = vim.api
local r = a.nvim_replace_termcodes
local p = a.nvim_get_proc
local c = a.nvim_get_proc_children
local k = a.nvim_set_keymap
local d = r("<C-\\><C-n>", true, true, true)

local function t(s) return r(s, true, true, true) end

local function f(i, e)
  local x = p(i)
  if x then
    if e[x.name] then return true end
    local h = c(i)
    for _, w in ipairs(h) do if f(w, e) then return true end end
  end
  return false
end

function M.smart_esc(z) return f(z, M.except) and t(M.key) or d end

local function s(l)
  local x = {}
  for _, v in ipairs(l) do x[v] = true end
  return x
end

function M.setup(g)
  M.key = g and g.key or "<Esc>"
  M.except = g and g.except and s(g.except) or { nvim = true }
  _G.termesc = M
  local o = { noremap = true, expr = true }
  k("t", M.key, "v:lua.termesc.smart_esc(b:terminal_job_pid)", o)
end

return M
