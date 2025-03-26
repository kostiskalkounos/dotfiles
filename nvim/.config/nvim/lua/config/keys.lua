local set = vim.keymap.set

local default = { noremap = true, unique = true, silent = true }
local expr = { noremap = true, unique = true, expr = true, silent = true }
local special = { noremap = true, silent = true }
local unique = { noremap = true, unique = true }

vim.g.mapleader = " "

set("c", "<C-a>", "<Home>", unique)
set("c", "<C-e>", "<End>", unique)
set("c", "<C-n>", "<Down>", unique)
set("c", "<C-p>", "<Up>", unique)
set("c", "<M-b>", "<S-Left>", unique)
set("c", "<M-f>", "<S-Right>", unique)
set("c", "Q", "q", unique)

set("i", "<space>", "<space><c-g>u", default)

set("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], default)

set("n", "-", "<CMD>Oil<CR>", unique)

set("n", "<M-h>", "<cmd>vertical resize -2<CR>", unique)
set("n", "<M-j>", "<cmd>resize -2<CR>", unique)
set("n", "<M-k>", "<cmd>resize +2<CR>", unique)
set("n", "<M-l>", "<cmd>vertical resize +2<CR>", unique)

set("i", "<M-j>", "<Esc><cmd>m .+1<CR>==gi", unique)
set("i", "<M-k>", "<Esc><cmd>m .-2<CR>==gi", unique)
set("v", "<M-j>", ":m '>+1<CR>gv=gv", default)
set("v", "<M-k>", ":m '<-2<CR>gv=gv", default)

set("n", "<C-j>", "<cmd>cnext<CR>", unique)
set("n", "<C-k>", "<cmd>cprev<CR>", unique)
set("n", "<C-h>", "<cmd>lprev<CR>", unique)
set("n", "<C-l>", "<cmd>lnext<CR>", special)

set("v", "<C-j>", "<cmd>cnext<CR>", unique)
set("v", "<C-k>", "<cmd>cprev<CR>", unique)
set("v", "<C-h>", "<cmd>lprev<CR>", unique)
set("v", "<C-l>", "<cmd>lnext<CR>", special)

set("n", "<Esc>", "<cmd>nohlsearch<cr>", unique)
set("n", "j", [[v:count == 0 ? "gj" : "j"]], expr)
set("n", "k", [[v:count == 0 ? "gk" : "k"]], expr)
set("v", "<", "<gv", default)
set("v", "<S-Tab>", "<gv", special)
set("v", "<Tab>", ">gv", special)
set("v", ">", ">gv", default)
set("v", "j", "gj", default)
set("v", "k", "gk", default)
set("v", "p", [["_dP]], default)

set("n", "<leader>0", "<cmd>tabl<cr>", unique)
set("n", "<leader>1", "1gt", default)
set("n", "<leader>2", "2gt", default)
set("n", "<leader>3", "3gt", default)
set("n", "<leader>4", "4gt", default)
set("n", "<leader>5", "5gt", default)
set("n", "<leader>6", "6gt", default)
set("n", "<leader>7", "7gt", default)
set("n", "<leader>8", "8gt", default)
set("n", "<leader>9", "9gt", default)

set("n", "<leader>H", "<C-w>H", default)
set("n", "<leader>J", "<C-w>J", default)
set("n", "<leader>K", "<C-w>K", default)
set("n", "<leader>L", "<C-w>L", default)
set("n", "<leader>h", "<C-w>h", default)
set("n", "<leader>j", "<C-w>j", default)
set("n", "<leader>k", "<C-w>k", default)
set("n", "<leader>l", "<C-w>l", default)

set("", "<leader>X", "<cmd>!open %<cr><cr>", unique)
set("n", "<Leader>n", "<cmd>bn<CR>", unique)
set("n", "<Leader>p", "<cmd>bp<CR>", unique)
set("n", "<leader>+", ":set nu! rnu!<CR>", unique)
set("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", unique)
set("n", "<leader>;", "<cmd>NvimTreeToggle<CR>", unique)
set("n", "<leader><leader>", "<C-^>", default)
set("n", "<leader>?", "<cmd>Telescope oldfiles<CR>", unique)
set("n", "<leader>A", "<cmd>Telescope grep_string<CR>", unique)
set("n", "<leader>D", "<cmd>DiffviewOpen<CR>", unique)
set("n", "<leader>F", "<cmd>NvimTreeRefresh<CR>", unique)
set("n", "<leader>G", "<cmd>Gitsigns blame<CR>", unique)
set("n", "<leader>I", "<cmd>buffers<CR>:buffer<Space>", unique)
set("n", "<leader>O", ":h <C-R>=expand('<cword>')<CR><CR>", unique)
set("n", "<leader>Q", "<cmd>qa<CR>", unique)
set("n", "<leader>S", "<cmd>Neogit<CR>", unique)
set("n", "<leader>T", "<cmd>Vterm<CR>", unique)
set("n", "<leader>U", "<cmd>DiffviewRefresh<CR>", unique)
set("n", "<leader>V", "<cmd>set paste!<CR>", unique)
set("n", "<leader>W", "<cmd>FormatToggle<CR>", unique)
set("n", "<leader>a", "<cmd>Telescope live_grep<CR>", unique)
set("n", "<leader>d", "<cmd>Telescope resume<CR>", unique)
set("n", "<leader>f", "<cmd>NvimTreeOpen<CR>", unique)
set("n", "<leader>i", "<cmd>Telescope buffers<CR>", unique)
set("n", "<leader>m", "<cmd>setlocal spell! spelllang=en_us<CR>", unique)
set("n", "<leader>s", "<cmd>Telescope find_files follow=true hidden=true<CR>", unique)
set("n", "<leader>t", "<cmd>Term<CR>", unique)
set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", unique)
set("n", "<leader>w", "<cmd>w<CR>", unique)
set("n", "<leader>x", "<cmd>x<CR>", unique)
set("n", "<leader>z", "za", default)
set("v", "<leader>a", "<cmd>Telescope grep_string<CR>", unique)

set("n", "<leader>E", "vip:sort iu<CR>", default)
set("n", "<leader>e", "vip:sort u<CR>", default)
set("v", "<leader>E", ":sort iu<CR>", default)
set("v", "<leader>e", ":sort u<CR>", default)

set("n", "<leader>'", "<cmd>vsp<CR>", unique)
set("n", "<leader>-", "<cmd>sp<CR>", unique)
set("n", "<leader>=", "<cmd>sp<CR>", unique)
set("n", "<leader>\\", "<cmd>vsp<CR>", unique)

set("n", "<leader>C", [[gg"+yG]], default)
set("n", "<leader>v", [["+p]], default)
set("v", "<leader>c", [["+y]], default)
set("v", "<leader>p", "p", default)
set("v", "<leader>v", [["+p]], default)

set("n", "<leader>B", function()
  require("spectre").open()
end, unique)
set("n", "<leader>b", function()
  require("spectre").open_visual({ select_word = true })
end, unique)
set("v", "<leader>b", function()
  require("spectre").open_visual()
end, unique)

set("n", "<leader>q", function()
  require("config.buffers").close_buffer()
end, unique)

set("n", "<F1>", function()
  require("dap").continue()
end, default)
set("n", "<F2>", function()
  require("dap").step_over()
end, default)
set("n", "<F3>", function()
  require("dap").step_into()
end, default)
set("n", "<F4>", function()
  require("dap").step_out()
end, default)
set("n", "<F5>", function()
  require("dap").step_back()
end, default)
set("n", "<F6>", function()
  require("dap").repl.open()
end, default)
set("n", "<F7>", function()
  require("dap").toggle_breakpoint()
end, default)
set("n", "<F8>", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, default)

vim.cmd([[
  augroup Terminal
    au!
    au TermOpen * setlocal nonumber norelativenumber
  augroup end

  command! -nargs=* Term split | terminal <args>
  command! -nargs=* Vterm vsplit | terminal <args>
]])
