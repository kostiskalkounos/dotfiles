local M = {}

vim.g.mapleader = " "

vim.opt.laststatus = 0
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.signcolumn = "no"

local default = { noremap = true, unique = true, silent = true }
local set = vim.keymap.set

set("n", "q", "<cmd>qa!<CR>", default)
set("n", "y", [["+y]], default)
set("v", "y", [["+y]], default)

local term_buf = vim.api.nvim_create_buf(true, false)
local term_io = vim.api.nvim_open_term(term_buf, {})

local group = vim.api.nvim_create_augroup("kitty", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  buffer = term_buf,
  command = "stopinsert",
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  pattern = "*",
  once = true,
  callback = function(ev)
    local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
    for _, line in ipairs(lines) do
      vim.api.nvim_chan_send(term_io, line .. "\r\n")
    end
    vim.api.nvim_win_set_buf(0, term_buf)
    vim.api.nvim_buf_delete(ev.buf, { force = true })
  end,
})

vim.api.nvim_create_augroup("start_at_bottom", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = "start_at_bottom",
  command = "normal! G",
})

return M
