local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150, on_macro = true })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
  group = augroup("Jenkinsfile"),
  pattern = { "Jenkinsfile*" },
  callback = function()
    vim.cmd([[set filetype=groovy]])
  end,
})

local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local function set_cursorline(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end

set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")
