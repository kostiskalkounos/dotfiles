local set = vim.keymap.set
local vimapi = vim.api
local vimfn = vim.fn
local vimv = vim.v

local default = { noremap = true, unique = true, silent = true }
local expr = { noremap = true, unique = true, expr = true, silent = true }
local special = { noremap = true, silent = true }
local unique = { noremap = true, unique = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

set("c", "<C-a>", "<Home>", unique)
set("c", "<C-e>", "<End>", unique)
set("c", "<C-n>", "<Down>", unique)
set("c", "<C-p>", "<Up>", unique)
set("c", "<M-b>", "<S-Left>", unique)
set("c", "<M-f>", "<S-Right>", unique)
set("c", "Q", "q", unique)

set("i", "<space>", "<space><c-g>u", default)
set("i", "<M-bs>", "<C-W>", default)

set("n", "-", "<cmd>Oil<cr>", unique)
set("n", "<esc>", "<cmd>nohlsearch<cr>", unique)

set("n", "<M-h>", "<cmd>vertical resize -2<cr>", unique)
set("n", "<M-j>", "<cmd>resize -2<cr>", unique)
set("n", "<M-k>", "<cmd>resize +2<cr>", unique)
set("n", "<M-l>", "<cmd>vertical resize +2<cr>", unique)

set("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", unique)
set("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", unique)
set("v", "<M-j>", ":m '>+1<cr>gv=gv", default)
set("v", "<M-k>", ":m '<-2<cr>gv=gv", default)

set({ "n", "v" }, "<C-j>", "<cmd>cnext<cr>", unique)
set({ "n", "v" }, "<C-k>", "<cmd>cprev<cr>", unique)
set({ "n", "v" }, "<C-h>", "<cmd>lprev<cr>", unique)
set({ "n", "v" }, "<C-l>", "<cmd>lnext<cr>", special)

set("v", "<", "<gv", default)
set("v", "<S-Tab>", "<gv", special)
set("v", "<Tab>", ">gv", special)
set("v", ">", ">gv", default)
set("v", "p", [["_dP]], default)

set("n", "<leader>0", "<cmd>tabl<cr>", unique)
for i = 1, 9 do
  set("n", "<leader>" .. i, "<cmd>tabnext " .. i .. "<cr>", default)
end

set("n", "<leader>H", "<cmd>wincmd H<cr>", default)
set("n", "<leader>J", "<cmd>wincmd J<cr>", default)
set("n", "<leader>K", "<cmd>wincmd K<cr>", default)
set("n", "<leader>L", "<cmd>wincmd L<cr>", default)
set("n", "<leader>h", "<cmd>wincmd h<cr>", default)
set("n", "<leader>j", "<cmd>wincmd j<cr>", default)
set("n", "<leader>k", "<cmd>wincmd k<cr>", default)
set("n", "<leader>l", "<cmd>wincmd l<cr>", default)

set("", "<leader>X", "<cmd>!open %<cr><cr>", unique)
set("n", "<Leader>n", "<cmd>bn<cr>", unique)
set("n", "<Leader>p", "<cmd>bp<cr>", unique)
set("n", "<leader>/", "<cmd>FzfLua lgrep_curbuf<cr>", unique)
set("n", "<leader>;", "<cmd>NvimTreeToggle<cr>", unique)
set("n", "<leader><leader>", "<C-^>", default)
set("n", "<leader>?", "<cmd>FzfLua oldfiles<cr>", unique)
set("n", "<leader>A", "<cmd>FzfLua lines<cr>", unique)
set("n", "<leader>D", "<cmd>DiffviewOpen<cr>", unique)
set("n", "<leader>F", "<cmd>NvimTreeRefresh<cr>", unique)
set("n", "<leader>G", "<cmd>Gitsigns blame<cr>", unique)
set("n", "<leader>I", "<cmd>FzfLua lsp_finder<cr>", unique)
set("n", "<leader>O", "<cmd>OpenInGHFileLines<cr>", unique)
set("n", "<leader>S", "<cmd>Neogit<cr>", unique)
set("n", "<leader>T", "<cmd>Vterm<cr>", unique)
set("n", "<leader>U", "<cmd>bufdo set nu! rnu!<cr>", unique)
set("n", "<leader>V", "<cmd>set paste!<cr>", unique)
set("n", "<leader>W", "<cmd>FormatToggle<cr>", unique)
set("n", "<leader>Z", "<cmd>setlocal spell! spelllang=en_us<cr>", unique)
set("n", "<leader>a", "<cmd>FzfLua live_grep<cr>", unique)
set("n", "<leader>b", "<cmd>GrugFar<cr>", unique)
set("n", "<leader>d", "<cmd>FzfLua resume<cr>", unique)
set("n", "<leader>f", "<cmd>NvimTreeOpen<cr>", unique)
set("n", "<leader>i", "<cmd>FzfLua buffers<cr>", unique)
set("n", "<leader>s", "<cmd>FzfLua files<cr>", unique)
set("n", "<leader>t", "<cmd>Term<cr>", unique)
set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", unique)
set("n", "<leader>w", "<cmd>w<cr>", unique)
set("n", "<leader>x", "<cmd>x<cr>", unique)
set("n", "<leader>z", "za", default)
set("v", "<leader>a", "<cmd>FzfLua grep_visual<cr>", unique)
set("v", "<leader>b", "<cmd>GrugFarWithin<cr>", unique)

set("n", "<leader>E", "vip:sort iu<cr>", default)
set("n", "<leader>e", "vip:sort u<cr>", default)
set("v", "<leader>E", ":sort iu<cr>", default)
set("v", "<leader>e", ":sort u<cr>", default)

set("n", "<leader>'", "<cmd>vsp<cr>", unique)
set("n", "<leader>-", "<cmd>sp<cr>", unique)
set("n", "<leader>=", "<cmd>sp<cr>", unique)
set("n", "<leader>\\", "<cmd>vsp<cr>", unique)

set("n", "<leader>v", [["+p]], default)
set("v", "<leader>c", [["+y]], default)
set("v", "<leader>p", "p", default)
set("v", "<leader>v", [["+p]], default)

set("n", "j", function()
  return vimv.count == 0 and "gj" or "j"
end, expr)

set("n", "k", function()
  return vimv.count == 0 and "gk" or "k"
end, expr)

set("n", "<leader>Q", function()
  require("config.buffers").quit_all()
end, unique)

set("n", "<leader>q", function()
  require("config.buffers").close_buffer()
end, unique)

set("n", "<leader>C", function()
  local lines = vimapi.nvim_buf_get_lines(0, 0, -1, false)
  vimfn.setreg("+", lines, "l")
end, default)
