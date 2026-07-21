local g = vim.g
local vimv = vim.v
local set = vim.keymap.set

local default = { silent = true }
local expr = { expr = true, silent = true }
local unique = { unique = true, silent = true }

g.mapleader = " "
g.maplocalleader = " "

set("n", "j", function()
  return vimv.count == 0 and "gj" or "j"
end, expr)

set("n", "k", function()
  return vimv.count == 0 and "gk" or "k"
end, expr)

set("n", "<leader>0", "<cmd>tabl<cr>", unique)
for i = 1, 9 do
  set("n", "<leader>" .. i, "<cmd>tabnext " .. i .. "<cr>", default)
end

set("i", "<M-bs>", "<C-W>", default)
set("t", "<Esc>", "<C-\\><C-n>")
set({ "n", "t" }, "<C-;>", "<cmd>Fterm<cr>", default)

set("c", "<C-a>", "<Home>", unique)
set("c", "<C-e>", "<End>", unique)
set("c", "<C-n>", "<Down>", unique)
set("c", "<C-p>", "<Up>", unique)
set("c", "<M-b>", "<S-Left>", unique)
set("c", "<M-f>", "<S-Right>", unique)
set("c", "Q", "q", unique)

set("v", "<M-j>", ":m '>+1<cr>gv=gv", default)
set("v", "<M-k>", ":m '<-2<cr>gv=gv", default)

set("n", "<M-h>", "<cmd>vertical resize -2<cr>", unique)
set("n", "<M-j>", "<cmd>resize -2<cr>", unique)
set("n", "<M-k>", "<cmd>resize +2<cr>", unique)
set("n", "<M-l>", "<cmd>vertical resize +2<cr>", unique)

set({ "n", "v" }, "<C-j>", "<cmd>cnext<cr>", unique)
set({ "n", "v" }, "<C-k>", "<cmd>cprev<cr>", unique)
set({ "n", "v" }, "<C-h>", "<cmd>lprev<cr>", unique)
set({ "n", "v" }, "<C-l>", "<cmd>lnext<cr>", default)

set("v", "<", "<gv", default)
set("v", "<S-Tab>", "<gv", default)
set("v", "<Tab>", ">gv", default)
set("v", ">", ">gv", default)
set("v", "p", [["_dP]], default)

set("n", "<leader>H", "<cmd>wincmd H<cr>", default)
set("n", "<leader>J", "<cmd>wincmd J<cr>", default)
set("n", "<leader>K", "<cmd>wincmd K<cr>", default)
set("n", "<leader>L", "<cmd>wincmd L<cr>", default)
set("n", "<leader>h", "<cmd>wincmd h<cr>", default)
set("n", "<leader>j", "<cmd>wincmd j<cr>", default)
set("n", "<leader>k", "<cmd>wincmd k<cr>", default)
set("n", "<leader>l", "<cmd>wincmd l<cr>", default)

set("n", "<leader>'", "<cmd>vsp<cr>", unique)
set("n", "<leader>-", "<cmd>sp<cr>", unique)
set("n", "<leader>=", "<cmd>sp<cr>", unique)
set("n", "<leader>\\", "<cmd>vsp<cr>", unique)

set("", "<leader>X", "<cmd>!open %<cr><cr>", unique)
set("n", "<Leader>n", "<cmd>bn<cr>", unique)
set("n", "<Leader>p", "<cmd>bp<cr>", unique)
set("n", "<leader><leader>", "<C-^>", default)
set("n", "<leader>C", "<cmd>%y+<cr>", default)
set("n", "<leader>U", "<cmd>bufdo set nu! rnu!<cr>", unique)
set("n", "<leader>V", "<cmd>set paste!<cr>", unique)
set("n", "<leader>Z", "<cmd>setlocal spell! spelllang=en_us<cr>", unique)
set("n", "<leader>w", "<cmd>w<cr>", unique)
set("n", "<leader>x", "<cmd>x<cr>", unique)
set("n", "<leader>z", "za", default)
set("n", "<esc>", "<cmd>nohlsearch<cr>", unique)

set("n", "<leader>v", [["+p]], default)
set("v", "<leader>c", [["+y]], default)
set("v", "<leader>p", "p", default)
set("v", "<leader>v", [["+p]], default)

set("n", "<leader>E", "vip:sort iu<cr>", default)
set("n", "<leader>e", "vip:sort u<cr>", default)
set("v", "<leader>E", ":sort iu<cr>", default)
set("v", "<leader>e", ":sort u<cr>", default)

set("n", "<leader>O", "<cmd>OpenInGHFileLines<cr>", unique)
set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", unique)

set("n", "-", function() require("oil").open() end, unique)
set("n", "<leader>/", function() require("fzf-lua").lgrep_curbuf() end, unique)
set("n", "<leader>;", function() require("nvim-tree.api").tree.toggle() end, unique)
set("n", "<leader>?", function() require("fzf-lua").oldfiles() end, unique)
set("n", "<leader>A", function() require("fzf-lua").lines() end, unique)
set("n", "<leader>D", function() require("diffview").open({}) end, unique)
set("n", "<leader>F", function() require("nvim-tree.api").tree.reload() end, unique)
set("n", "<leader>G", function() require("gitsigns").blame() end, unique)
set("n", "<leader>I", function() require("fzf-lua").lsp_finder() end, unique)
set("n", "<leader>Q", function() require("config.buffers").quit_all() end, unique)
set("n", "<leader>S", function() require("neogit").open() end, unique)
set("n", "<leader>a", function() require("fzf-lua").live_grep() end, unique)
set("n", "<leader>b", function() require("grug-far").open() end, unique)
set("n", "<leader>d", function() require("fzf-lua").resume() end, unique)
set("n", "<leader>f", function() require("nvim-tree.api").tree.open() end, unique)
set("n", "<leader>i", function() require("fzf-lua").buffers() end, unique)
set("n", "<leader>q", function() require("config.buffers").close_buffer() end, unique)
set("n", "<leader>s", function() require("fzf-lua").files() end, unique)
set("v", "<leader>a", function() require("fzf-lua").grep_visual() end, unique)
set("v", "<leader>b", function() require("grug-far").with_visual_selection() end, unique)

local function toggle_format()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
end
vim.api.nvim_create_user_command("FormatToggle", toggle_format, {})
set("n", "<leader>W", toggle_format, unique)
