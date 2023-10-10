local M = {}

vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.ignorecase = true
vim.opt.laststatus = 0
vim.opt.mouse = "a"
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.timeout = false
vim.opt.ttimeout = false
vim.opt.ttimeoutlen = 0
vim.opt.virtualedit = "block"

local default = { noremap = true, unique = true, silent = true }
vim.g.mapleader = " "
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", default)
vim.keymap.set("n", "<leader>U", ":set nu! rnu!<CR>", default)
vim.keymap.set("n", "<leader>q", "<cmd>qa!<CR>", default)
vim.keymap.set("n", "q", "<cmd>qa!<CR>", default)
vim.keymap.set("v", "<leader>c", "y", default)

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
  augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup="Visual", timeout=150, on_macro=true }
  augroup END

  augroup start_at_bottom
  autocmd!
  autocmd VimEnter * normal G
  augroup END

  augroup prevent_insert
  autocmd!
  autocmd TermEnter * stopinsert
  augroup END

  hi CursorLine guifg=NONE ctermfg=NONE guibg=#2c323c ctermbg=236 gui=NONE cterm=NONE
  hi CursorLineNr guifg=#abb2bf ctermfg=249 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi ErrorMsg guifg=#e06c75 ctermfg=168 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi IncSearch guifg=#282c34 ctermfg=236 guibg=#c678dd ctermbg=176 gui=NONE cterm=NONE
  hi LineNr guifg=#4b5263 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi NonText guifg=#3b4048 ctermfg=238 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Search guifg=#282c34 ctermfg=236 guibg=#61afef ctermbg=75 gui=NONE cterm=NONE
  hi Visual guifg=NONE ctermfg=NONE guibg=#3e4452 ctermbg=238 gui=NONE cterm=NONE
]])

return M
