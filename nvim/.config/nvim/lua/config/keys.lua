local default = { noremap = true, unique = true, silent = true }
local expr = { noremap = true, unique = true, expr = true, silent = true }
local special = { noremap = true, silent = true }
local unique = { noremap = true, unique = true }

vim.g.mapleader = " "

vim.keymap.set("c", "<C-a>", "<Home>", unique)
vim.keymap.set("c", "<C-e>", "<End>", unique)
vim.keymap.set("c", "<C-n>", "<Down>", unique)
vim.keymap.set("c", "<C-p>", "<Up>", unique)
vim.keymap.set("c", "<M-b>", "<S-Left>", unique)
vim.keymap.set("c", "<M-f>", "<S-Right>", unique)
vim.keymap.set("c", "Q", "q", unique)

vim.keymap.set("i", "<space>", "<space><c-g>u", default)

vim.keymap.set("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], default)

vim.keymap.set("n", "<M-h>", "<cmd>vertical resize -2<CR>", unique)
vim.keymap.set("n", "<M-j>", "<cmd>resize -2<CR>", unique)
vim.keymap.set("n", "<M-k>", "<cmd>resize +2<CR>", unique)
vim.keymap.set("n", "<M-l>", "<cmd>vertical resize +2<CR>", unique)

vim.keymap.set("i", "<M-j>", "<Esc><cmd>m .+1<CR>==gi", unique)
vim.keymap.set("i", "<M-k>", "<Esc><cmd>m .-2<CR>==gi", unique)
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", default)
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", default)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>", unique)
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>", unique)
vim.keymap.set("n", "<C-h>", "<cmd>lprev<CR>", unique)
vim.keymap.set("n", "<C-l>", "<cmd>lnext<CR>", special)

vim.keymap.set("v", "<C-j>", "<cmd>cnext<CR>", unique)
vim.keymap.set("v", "<C-k>", "<cmd>cprev<CR>", unique)
vim.keymap.set("v", "<C-h>", "<cmd>lprev<CR>", unique)
vim.keymap.set("v", "<C-l>", "<cmd>lnext<CR>", special)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", unique)
vim.keymap.set("n", "j", [[v:count == 0 ? "gj" : "j"]], expr)
vim.keymap.set("n", "k", [[v:count == 0 ? "gk" : "k"]], expr)
vim.keymap.set("v", "<", "<gv", default)
vim.keymap.set("v", ">", ">gv", default)
vim.keymap.set("v", "j", "gj", default)
vim.keymap.set("v", "k", "gk", default)
vim.keymap.set("v", "p", [["_dP]], default)

vim.keymap.set("n", "<leader>0", "<cmd>tabl<cr>", unique)
vim.keymap.set("n", "<leader>1", "1gt", default)
vim.keymap.set("n", "<leader>2", "2gt", default)
vim.keymap.set("n", "<leader>3", "3gt", default)
vim.keymap.set("n", "<leader>4", "4gt", default)
vim.keymap.set("n", "<leader>5", "5gt", default)
vim.keymap.set("n", "<leader>6", "6gt", default)
vim.keymap.set("n", "<leader>7", "7gt", default)
vim.keymap.set("n", "<leader>8", "8gt", default)
vim.keymap.set("n", "<leader>9", "9gt", default)

vim.keymap.set("n", "<leader>H", "<C-w>H", default)
vim.keymap.set("n", "<leader>J", "<C-w>J", default)
vim.keymap.set("n", "<leader>K", "<C-w>K", default)
vim.keymap.set("n", "<leader>L", "<C-w>L", default)
vim.keymap.set("n", "<leader>h", "<C-w>h", default)
vim.keymap.set("n", "<leader>j", "<C-w>j", default)
vim.keymap.set("n", "<leader>k", "<C-w>k", default)
vim.keymap.set("n", "<leader>l", "<C-w>l", default)

vim.keymap.set("", "<leader>X", "<cmd>!open %<cr><cr>", unique)
vim.keymap.set("n", "<Leader>n", "<cmd>bn<CR>", unique)
vim.keymap.set("n", "<Leader>p", "<cmd>bp<CR>", unique)
vim.keymap.set("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", unique)
vim.keymap.set("n", "<leader>;", "<cmd>NvimTreeToggle<CR>", unique)
vim.keymap.set("n", "<leader><leader>", "<C-^>", default)
vim.keymap.set("n", "<leader>?", "<cmd>Telescope oldfiles<CR>", unique)
vim.keymap.set("n", "<leader>A", "<cmd>Telescope grep_string<CR>", unique)
vim.keymap.set("n", "<leader>B", "<cmd>lua require('spectre').open()<CR>", unique)
vim.keymap.set("n", "<leader>D", "<cmd>DiffviewRefresh<CR>", unique)
vim.keymap.set("n", "<leader>F", "<cmd>NvimTreeRefresh<CR>", unique)
vim.keymap.set("n", "<leader>G", "<cmd>Gitsigns blame_line<CR>", unique)
vim.keymap.set("n", "<leader>I", "<cmd>buffers<CR>:buffer<Space>", unique)
vim.keymap.set("n", "<leader>O", ":h <C-R>=expand('<cword>')<CR><CR>", unique)
vim.keymap.set("n", "<leader>Q", "<cmd>qa<CR>", unique)
vim.keymap.set("n", "<leader>S", "<cmd>Neogit<CR>", unique)
vim.keymap.set("n", "<leader>T", "<cmd>Vterm<CR>", unique)
vim.keymap.set("n", "<leader>U", ":set nu! rnu!<CR>", unique)
vim.keymap.set("n", "<leader>V", "<cmd>set paste!<CR>", unique)
vim.keymap.set("n", "<leader>a", "<cmd>Telescope live_grep<CR>", unique)
vim.keymap.set("n", "<leader>b", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", unique)
vim.keymap.set("n", "<leader>d", "<cmd>DiffviewOpen<CR>", unique)
vim.keymap.set("n", "<leader>f", "<cmd>NvimTreeOpen<CR>", unique)
vim.keymap.set("n", "<leader>i", "<cmd>Telescope buffers<CR>", unique)
vim.keymap.set("n", "<leader>m", "<cmd>setlocal spell! spelllang=en_us<CR>", unique)
vim.keymap.set("n", "<leader>q", "<cmd>lua require('config.utils').close_buffer()<CR>", unique)
vim.keymap.set("n", "<leader>s", "<cmd>Telescope find_files follow=true hidden=true<CR>", unique)
vim.keymap.set("n", "<leader>t", "<cmd>Term<CR>", unique)
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", unique)
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", unique)
vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", unique)
vim.keymap.set("n", "<leader>z", "za", default)
vim.keymap.set("v", "<leader>a", "<cmd>Telescope grep_string<CR>", unique)
vim.keymap.set("v", "<leader>b", "<cmd>lua require('spectre').open_visual()<CR>", unique)

vim.keymap.set("n", "<F1>", ":lua require'dap'.continue()<CR>", default)
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_over()<CR>", default)
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_into()<CR>", default)
vim.keymap.set("n", "<F4>", ":lua require'dap'.step_out()<CR>", default)
vim.keymap.set("n", "<F5>", ":lua require'dap'.step_back()<CR>", default)
vim.keymap.set("n", "<F6>", ":lua require'dap'.repl.open()<CR>", default)
vim.keymap.set("n", "<F7>", ":lua require'dap'.toggle_breakpoint()<CR>", default)
vim.keymap.set("n", "<F8>", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", default)

vim.keymap.set("n", "<leader>E", "vip:sort iu<CR>", default)
vim.keymap.set("n", "<leader>e", "vip:sort u<CR>", default)
vim.keymap.set("v", "<leader>E", ":sort iu<CR>", default)
vim.keymap.set("v", "<leader>e", ":sort u<CR>", default)

vim.keymap.set("n", "<leader>'", "<cmd>vsp<CR>", unique)
vim.keymap.set("n", "<leader>-", "<cmd>sp<CR>", unique)
vim.keymap.set("n", "<leader>=", "<cmd>sp<CR>", unique)
vim.keymap.set("n", "<leader>\\", "<cmd>vsp<CR>", unique)

vim.keymap.set("n", "<leader>C", [[gg"+yG]], default)
vim.keymap.set("n", "<leader>c", [["+y]], default)
vim.keymap.set("n", "<leader>v", [["+p]], default)
vim.keymap.set("v", "<leader>c", [["+y]], default)
vim.keymap.set("v", "<leader>p", "p", default)
vim.keymap.set("v", "<leader>v", [["+p]], default)

vim.cmd([[
  augroup HighlightYank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=150, on_macro=true}
  augroup end

  augroup Jenkinsfile
  au!
  autocmd BufRead,BufNewFile Jenkinsfile* set filetype=groovy
  augroup end

  augroup Terminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup end

  command! -nargs=* Term split | terminal <args>
  command! -nargs=* Vterm vsplit | terminal <args>
]])
