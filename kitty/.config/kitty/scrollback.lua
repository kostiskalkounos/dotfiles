local api = vim.api
local default = { noremap = true, unique = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set
local o = vim.o

if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
  vim.g.clipboard = {
    name = "pbcopy",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
end
vim.opt.clipboard = "unnamedplus"

o.background = "dark"
o.cursorline = false
o.fillchars = "eob: "
o.ignorecase = true
o.laststatus = 0
o.number = false
o.relativenumber = false
o.ruler = true
o.showmode = false
o.signcolumn = "no"
o.smartcase = true
o.termguicolors = true
o.scrollback = 100000

api.nvim_set_hl(0, "NonText", { ctermbg = "none" })
api.nvim_set_hl(0, "Normal", { ctermbg = "none" })
api.nvim_set_hl(0, "Visual", { bg = "#949cbb" })
api.nvim_set_hl(0, "Search", { fg = "#24273A", bg = "#89b4fa" })
api.nvim_set_hl(0, "CurSearch", { fg = "#24273A", bg = "#cba6f7" })

set("n", "<Esc>", "<cmd>nohlsearch<cr>", default)
set("n", "q", "<cmd>qa!<cr>", default)
set({ "n", "v" }, "y", [["+y]], default)
set("v", "<leader>c", [["+y]], default)
set("n", "<leader>C", [[gg"+yG]], default)

local term_buf = api.nvim_create_buf(false, true)
local term_io = api.nvim_open_term(term_buf, {})
local group = api.nvim_create_augroup("kitty_scrollback", { clear = true })

api.nvim_create_autocmd("ModeChanged", {
  group = group,
  buffer = term_buf,
  callback = function()
    if vim.fn.mode() == "t" then
      vim.cmd("stopinsert")
    end
  end,
})

api.nvim_create_autocmd("VimEnter", {
  group = group,
  once = true,
  callback = function(ev)
    local lines = api.nvim_buf_get_lines(ev.buf, 0, -1, false)
    while #lines > 0 and lines[#lines]:match("^%s*$") do
      table.remove(lines)
    end
    local line_count = #lines
    if line_count > 0 then
      local chunk_size = 2000
      for i = 1, line_count, chunk_size do
        local j = math.min(i + chunk_size - 1, line_count)
        api.nvim_chan_send(term_io, table.concat(lines, "\r\n", i, j) .. "\r\n")
      end
    end

    api.nvim_win_set_buf(0, term_buf)
    api.nvim_buf_delete(ev.buf, { force = true })
    api.nvim_command("normal! A")
  end,
})
