local api_nvim_create_augroup = vim.api.nvim_create_augroup
local api_nvim_create_autocmd = vim.api.nvim_create_autocmd
local api_nvim_create_user_command = vim.api.nvim_create_user_command
local api_nvim_command = vim.api.nvim_command
local opt_local = vim.opt_local
local cmd = vim.cmd

api_nvim_create_autocmd("TextYankPost", {
  group = api_nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 150, on_macro = true }) end
})

api_nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
  group = api_nvim_create_augroup("Jenkinsfile", { clear = true }),
  pattern = "Jenkinsfile*",
  callback = function() vim.bo.filetype = "groovy" end
})

local g = api_nvim_create_augroup("CursorLineControl", { clear = true })
api_nvim_create_autocmd("WinLeave", { group = g, callback = function() opt_local.cursorline = false end })
api_nvim_create_autocmd("WinEnter", { group = g, callback = function() opt_local.cursorline = true end })
api_nvim_create_autocmd("FileType",
  { group = g, pattern = "TelescopePrompt", callback = function() opt_local.cursorline = false end })

local t = api_nvim_create_augroup("Terminal", { clear = true })
api_nvim_create_autocmd("TermOpen", {
  group = t,
  pattern = "*",
  callback = function()
    opt_local.number = false
    opt_local.relativenumber = false
    cmd("startinsert!")
  end
})

api_nvim_create_user_command("Term", function(o)
  api_nvim_command("split")
  api_nvim_command("resize 15")
  api_nvim_command("terminal " .. o.args)
end, { nargs = "*", complete = "file" })

api_nvim_create_user_command("Vterm", function(o)
  api_nvim_command("vsplit")
  api_nvim_command("terminal " .. o.args)
end, { nargs = "*", complete = "file" })
