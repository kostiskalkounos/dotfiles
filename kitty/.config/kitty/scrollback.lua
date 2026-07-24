local api = vim.api
local default = { noremap = true, unique = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set
local o = vim.o

local home = os.getenv("HOME") or ""
local theme = "dark"
local theme_file = io.open(home .. "/.cache/theme", "r")
if theme_file then
  theme = theme_file:read("*l") or "dark"
  theme_file:close()
end

o.background = theme
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
o.shada = "'0,<0,f0,:100,@0,/100"

api.nvim_set_hl(0, "NonText", { ctermbg = "none" })
api.nvim_set_hl(0, "Normal", { ctermbg = "none" })

if theme == "light" then
  api.nvim_set_hl(0, "Visual", { bg = "#bcc0cd" })
  api.nvim_set_hl(0, "Search", { fg = "#4c4f6a", bg = "#a8d2f1" })
  api.nvim_set_hl(0, "CurSearch", { fg = "#e6e9f0", bg = "#8839f0" })
else
  api.nvim_set_hl(0, "Visual", { bg = "#494d65" })
  api.nvim_set_hl(0, "Search", { fg = "#cad3f6", bg = "#455c6e" })
  api.nvim_set_hl(0, "CurSearch", { fg = "#1e2031", bg = "#c6a0f7" })
end

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
    local last_non_empty = vim.fn.prevnonblank(api.nvim_buf_line_count(ev.buf))

    if last_non_empty > 0 then
      local chunk_size = 5000
      for i = 0, last_non_empty - 1, chunk_size do
        local end_idx = math.min(i + chunk_size, last_non_empty)
        local chunk_lines = api.nvim_buf_get_lines(ev.buf, i, end_idx, false)
        if end_idx == last_non_empty then
          api.nvim_chan_send(term_io, table.concat(chunk_lines, "\r\n"))
        else
          chunk_lines[#chunk_lines + 1] = ""
          api.nvim_chan_send(term_io, table.concat(chunk_lines, "\r\n"))
        end
      end
    end

    api.nvim_win_set_buf(0, term_buf)
    api.nvim_buf_delete(ev.buf, { force = true })

    if last_non_empty > 0 then
      local target_line = math.min(last_non_empty, o.scrollback)
      local retries = 0
      local function try_set_cursor()
        if api.nvim_buf_is_valid(term_buf) then
          local cur_lines = api.nvim_buf_line_count(term_buf)
          if cur_lines >= target_line then
            pcall(api.nvim_win_set_cursor, 0, { target_line, 0 })
          elseif retries < 50 then
            retries = retries + 1
            vim.defer_fn(try_set_cursor, 2)
          end
        end
      end
      vim.schedule(try_set_cursor)
    end
  end,
})
