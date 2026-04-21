local api = vim.api
local opt_local = vim.opt_local

local api_nvim_command = api.nvim_command
local api_nvim_create_augroup = api.nvim_create_augroup
local api_nvim_create_autocmd = api.nvim_create_autocmd
local api_nvim_create_user_command = api.nvim_create_user_command

api_nvim_create_autocmd("TextYankPost", {
  group = api_nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150, on_macro = false })
  end,
})

vim.filetype.add({
  pattern = {
    ["Jenkinsfile.*"] = "groovy",
    ["Dockerfile.*"] = "dockerfile",
  },
})

local g = api_nvim_create_augroup("CursorLineControl", { clear = true })
api_nvim_create_autocmd("WinLeave", {
  group = g,
  callback = function()
    opt_local.cursorline = false
  end,
})
api_nvim_create_autocmd("WinEnter", {
  group = g,
  callback = function()
    opt_local.cursorline = true
  end,
})
api_nvim_create_autocmd("FileType", {
  group = g,
  pattern = "TelescopePrompt",
  callback = function()
    opt_local.cursorline = false
  end,
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
