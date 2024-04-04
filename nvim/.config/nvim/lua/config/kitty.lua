local M = {}

vim.opt.laststatus = 0
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.signcolumn = "no"

local default = { noremap = true, unique = true, silent = true }
vim.g.mapleader = " "
vim.keymap.set("n", "q", "<cmd>qa!<CR>", default)
vim.keymap.set("v", "y", [["+y]], default)

local term_buf = vim.api.nvim_create_buf(true, false)
local term_io = vim.api.nvim_open_term(term_buf, {})
local group = vim.api.nvim_create_augroup("kitty", {})

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
    local current_win = vim.fn.win_getid()
    for _, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)) do
      vim.api.nvim_chan_send(term_io, line)
      vim.api.nvim_chan_send(term_io, "\r\n")
    end
    vim.api.nvim_win_set_buf(current_win, term_buf)
    vim.api.nvim_buf_delete(ev.buf, { force = true })
  end,
})

vim.cmd([[
  augroup start_at_bottom
  autocmd!
  autocmd VimEnter * normal G
  augroup END
]])

return M
