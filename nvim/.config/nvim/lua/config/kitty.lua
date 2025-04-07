vim.g.mapleader = " "
vim.o.laststatus = 0
vim.o.number = false
vim.o.relativenumber = false
vim.o.ruler = true
vim.o.scrollback = 10000
vim.o.signcolumn = "no"

local default = { noremap = true, unique = true, silent = true }
local set = vim.keymap.set

set("n", "q", "<cmd>qa!<CR>", default)
set("n", "y", [["+y]], default)
set("v", "y", [["+y]], default)

local term_buf = vim.api.nvim_create_buf(true, false)
local term_io = vim.api.nvim_open_term(term_buf, {})
local group = vim.api.nvim_create_augroup("opt", { clear = true })

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
    if #lines > 0 then
      vim.api.nvim_chan_send(term_io, table.concat(lines, "\r\n") .. "\r\n")
    end
    vim.api.nvim_win_set_buf(0, term_buf)
    vim.api.nvim_buf_delete(ev.buf, { force = true })
    vim.api.nvim_command("normal! G")
  end,
})
