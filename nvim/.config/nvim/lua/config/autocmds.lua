local api = vim.api
local opt_local = vim.opt_local

local function augroup(name)
  return api.nvim_create_augroup(name, { clear = true })
end

api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150, on_macro = true })
  end,
})

api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
  group = augroup("Jenkinsfile"),
  pattern = "Jenkinsfile*",
  callback = function()
    vim.cmd("set filetype=groovy")
  end,
})

local group = api.nvim_create_augroup("CursorLineControl", { clear = true })
local function set_cursorline(event, value, pattern)
  api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      opt_local.cursorline = value
    end,
  })
end

set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

local terminal_augroup = api.nvim_create_augroup("Terminal", { clear = true })
api.nvim_create_autocmd("TermOpen", {
  group = terminal_augroup,
  pattern = "*",
  callback = function()
    opt_local.number = false
    opt_local.relativenumber = false
    vim.cmd("startinsert!")
  end,
})

local function create_terminal_cmd(name, split_cmd, resize_lines)
  api.nvim_create_user_command(name, function(opts)
    api.nvim_command(split_cmd)
    if resize_lines then
      api.nvim_command("resize " .. resize_lines)
    end
    api.nvim_command("terminal " .. opts.args)
  end, { nargs = "*", complete = "file" })
end

create_terminal_cmd("Term", "split", 15)
create_terminal_cmd("Vterm", "vsplit")
