local map = vim.api.nvim_set_keymap

local default = { noremap = true, unique = true, silent = true }
local expr = { noremap = true, unique = true, expr = true, silent = true }
local special = { noremap = true, silent = true }
local unique = { noremap = true, unique = true }

vim.g.mapleader = " "

map("c", "<C-a>", "<Home>", unique)
map("c", "<C-b>", "<Left>", unique)
map("c", "<C-e>", "<End>", unique)
map("c", "<C-f>", "<Right>", unique)
map("c", "<C-h>", "<Left>", unique)
map("c", "<C-j>", "<Down>", unique)
map("c", "<C-k>", "<Up>", unique)
map("c", "<C-l>", "<Right>", unique)
map("c", "<C-n>", "<Down>", unique)
map("c", "<C-p>", "<Up>", unique)
map("c", "<M-b>", "<S-Left>", unique)
map("c", "<M-f>", "<S-Right>", unique)
map("c", "<M-n>", "<Down>", unique)
map("c", "<M-p>", "<Up>", unique)

map("i", "<C-h>", "<Left>", default)
map("i", "<C-j>", "<Down>", default)
map("i", "<C-k>", "<Up>", default)
map("i", "<C-l>", "<Right>", default)
map("i", "<space>", "<space><c-g>u", default)

map("t", "<Esc>", [[Find_proc_in_tree(b:terminal_job_pid, ["nvim", "fzf"], 0) ? "<Esc>" : "<c-\><c-n>"]], expr)
map("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], default)

map("n", "<C-h>", "<Left>", default)
map("n", "<C-j>", "<Down>", default)
map("n", "<C-k>", "<Up>", default)
map("n", "<C-l>", "<Right>", special)
map("v", "<C-h>", "<Left>", default)
map("v", "<C-j>", "<Down>", default)
map("v", "<C-k>", "<Up>", default)
map("v", "<C-l>", "<Right>", default)

map("n", "<M-h>", "<cmd>vertical resize -2<CR>", unique)
map("n", "<M-j>", "<cmd>resize -2<CR>", unique)
map("n", "<M-k>", "<cmd>resize +2<CR>", unique)
map("n", "<M-l>", "<cmd>vertical resize +2<CR>", unique)

map("i", "<M-j>", "<Esc><cmd>m .+1<CR>==gi", unique)
map("i", "<M-k>", "<Esc><cmd>m .-2<CR>==gi", unique)
map("v", "<M-j>", ":m '>+1<CR>gv=gv", default)
map("v", "<M-k>", ":m '<-2<CR>gv=gv", default)

map("n", "[b", "<cmd>bp<CR>", unique)
map("n", "[c", "<cmd>cp<CR>", unique)
map("n", "[l", "<cmd>lp<CR>", unique)
map("n", "[t", "<cmd>tabp<CR>", unique)
map("n", "]b", "<cmd>bn<CR>", unique)
map("n", "]c", "<cmd>cn<CR>", unique)
map("n", "]l", "<cmd>ln<CR>", unique)
map("n", "]t", "<cmd>tabn<CR>", unique)

map("n", "<Esc>", "<cmd>nohlsearch<cr>", unique)
map("n", "j", [[v:count == 0 ? "gj" : "j"]], expr)
map("n", "k", [[v:count == 0 ? "gk" : "k"]], expr)
map("v", "<", "<gv", default)
map("v", ">", ">gv", default)
map("v", "j", "gj", default)
map("v", "k", "gk", default)
map("v", "p", [["_dP]], default)

map("n", "<leader>0", "<cmd>tabl<cr>", unique)
map("n", "<leader>1", "1gt", default)
map("n", "<leader>2", "2gt", default)
map("n", "<leader>3", "3gt", default)
map("n", "<leader>4", "4gt", default)
map("n", "<leader>5", "5gt", default)
map("n", "<leader>6", "6gt", default)
map("n", "<leader>7", "7gt", default)
map("n", "<leader>8", "8gt", default)
map("n", "<leader>9", "9gt", default)

map("n", "<leader>H", "<C-w>H", default)
map("n", "<leader>J", "<C-w>J", default)
map("n", "<leader>K", "<C-w>K", default)
map("n", "<leader>L", "<C-w>L", default)
map("n", "<leader>h", "<C-w>h", default)
map("n", "<leader>j", "<C-w>j", default)
map("n", "<leader>k", "<C-w>k", default)
map("n", "<leader>l", "<C-w>l", default)

map("", "<leader>X", "<cmd>!open %<cr><cr>", unique)
map("n", "<Leader>n", "<cmd>bn<CR>", unique)
map("n", "<Leader>p", "<cmd>bp<CR>", unique)
map("n", "<leader><Tab>", "<cmd>ClangdSwitchSourceHeader<CR>", unique)
map("n", "<leader><leader>", "<C-^>", default)
map("n", "<leader>A", "<cmd>DiffviewOpen<CR>", unique)
map("n", "<leader>B", "<cmd>lua require('spectre').open()<CR>", unique)
map("n", "<leader>D", "<cmd>DiffviewRefresh<CR>", unique)
map("n", "<leader>F", "<cmd>NvimTreeRefresh<CR>", unique)
map("n", "<leader>I", "<cmd>buffers<CR>:buffer<Space>", unique)
map("n", "<leader>O", ":h <C-R>=expand('<cword>')<CR><CR>", unique)
map("n", "<leader>S", "<cmd>Neogit<CR>", unique)
map("n", "<leader>T", "<cmd>Vterm<CR>", unique)
map("n", "<leader>V", "<cmd>set paste!<CR>", unique)
map("n", "<leader>a", "<cmd>Telescope live_grep<CR>", unique)
map("n", "<leader>b", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", unique)
map("n", "<leader>d", "<cmd>Telescope grep_string<CR>", unique)
map("n", "<leader>f", "<cmd>NvimTreeToggle<CR>", unique)
map("n", "<leader>i", "<cmd>Telescope buffers<CR>", unique)
map("n", "<leader>m", "<cmd>setlocal spell! spelllang=en_us<CR>", unique)
map("n", "<leader>q", "<cmd>q<CR>", unique)
map("n", "<leader>s", "<cmd>Telescope find_files hidden=true<CR>", unique)
map("n", "<leader>t", "<cmd>Term<CR>", unique)
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", unique)
map("n", "<leader>w", "<cmd>w<CR>", unique)
map("n", "<leader>x", "<cmd>x<CR>", unique)
map("n", "<leader>z", "za", default)
map("v", "<leader>b", "<cmd>lua require('spectre').open_visual()<CR>", unique)

map("n", "<leader>E", "vip:sort iu<CR>", default)
map("n", "<leader>e", "vip:sort u<CR>", default)
map("v", "<leader>E", ":sort iu<CR>", default)
map("v", "<leader>e", ":sort u<CR>", default)

map("n", "<leader>'", "<cmd>vsp<CR>", unique)
map("n", "<leader>-", "<cmd>sp<CR>", unique)
map("n", "<leader>=", "<cmd>sp<CR>", unique)
map("n", "<leader>\\", "<cmd>vsp<CR>", unique)

map("n", "<leader>C", [[gg"+yG]], default)
map("n", "<leader>c", [["+y]], default)
map("n", "<leader>v", [["+p]], default)
map("v", "<leader>c", [["+y]], default)
map("v", "<leader>p", "p", default)
map("v", "<leader>v", [["+p]], default)

vim.cmd([[
  function! Find_proc_in_tree(rootpid, names, accum) abort
    if a:accum > 9 || !exists("*nvim_get_proc")
      return v:false
    endif
    let p = nvim_get_proc(a:rootpid)
    if !empty(p) && index(a:names, p.name) >= 0
      return v:true
    endif
    for c in nvim_get_proc_children(a:rootpid)[:9]
      if s:find_proc_in_tree(c, a:names, 1 + a:accum)
        return v:true
      endif
    endfor
    return v:false
  endfunction

  augroup highlightYank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=150, on_macro=true}
  augroup end

  augroup TrimWhiteSpace
    au!
    autocmd BufWritePre * :%s/\s\+$//e
  augroup END

  augroup terminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup end

  command! -nargs=* Term split | terminal <args>
  command! -nargs=* Vterm vsplit | terminal <args>
]])
