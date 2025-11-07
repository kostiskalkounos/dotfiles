local api = vim.api
local default = { noremap = true, unique = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local api_nvim_create_autocmd = api.nvim_create_autocmd
local set = vim.keymap.set
local o = vim.o

o.background = "dark"
o.cursorline = false
o.ignorecase = true
o.laststatus = 0
o.number = false
o.relativenumber = false
o.ruler = true
o.showmode = false
o.signcolumn = "no"
o.smartcase = true

api.nvim_set_hl(0, "NonText", { ctermbg = "none" })
api.nvim_set_hl(0, "Normal", { ctermbg = "none" })

api.nvim_set_hl(0, "Visual", { bg = "#949cbb" })
api.nvim_set_hl(0, "Search", { fg = "#24273a", bg = "#89b4fa" })
api.nvim_set_hl(0, "CurSearch", { fg = "#24273a", bg = "#cba6f7" })

set("n", "<Esc>", "<cmd>nohlsearch<cr>", default)
set("n", "q", "<cmd>qa!<cr>", default)
set({ "n", "v" }, "y", [["+y]], default)

set("n", "<leader>C", [[gg"+yG]], default)
set("v", "<leader>c", [["+y]], default)

local term_buf = api.nvim_create_buf(false, true)
local term_io = api.nvim_open_term(term_buf, {})
local group = api.nvim_create_augroup("opt", { clear = true })

api_nvim_create_autocmd("ModeChanged", {
	group = group,
	buffer = term_buf,
	command = "stopinsert",
})

api_nvim_create_autocmd("VimEnter", {
	group = group,
	once = true,
	callback = function(ev)
		local lines = api.nvim_buf_get_lines(ev.buf, 0, -1, false)
		if #lines > 0 then
			api.nvim_chan_send(term_io, table.concat(lines, "\r\n") .. "\r\n")
		end

		api.nvim_win_set_buf(0, term_buf)
		api.nvim_buf_delete(ev.buf, { force = true })
		api.nvim_command("normal! A")
	end,
})
