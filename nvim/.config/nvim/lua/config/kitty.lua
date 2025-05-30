local api = vim.api
local default = { noremap = true, unique = true, silent = true }

local api_nvim_create_autocmd = api.nvim_create_autocmd
local set = vim.keymap.set

vim.g.mapleader = " "
vim.o.laststatus = 0
vim.o.number = false
vim.o.relativenumber = false
vim.o.ruler = true
vim.o.scrollback = 10000
vim.o.signcolumn = "no"

set("n", "q", "<cmd>qa!<cr>", default)
set("n", "y", [["+y]], default)
set("v", "y", [["+y]], default)

local term_buf = api.nvim_create_buf(true, false)
local term_io = api.nvim_open_term(term_buf, {})
local group = api.nvim_create_augroup("opt", { clear = true })

api_nvim_create_autocmd("ModeChanged", {
  group = group,
  buffer = term_buf,
  command = "stopinsert",
})

api_nvim_create_autocmd("VimEnter", {
  group = group,
  pattern = "*",
  once = true,
  callback = function(ev)
    local lines = api.nvim_buf_get_lines(ev.buf, 0, -1, false)
    if #lines > 0 then
      api.nvim_chan_send(term_io, table.concat(lines, "\r\n") .. "\r\n")
    end
    api.nvim_win_set_buf(0, term_buf)
    api.nvim_buf_delete(ev.buf, { force = true })
    api.nvim_command("normal! G")
  end,
})
