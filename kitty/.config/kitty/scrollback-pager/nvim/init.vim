"set noruler
set background=dark
set clipboard+=unnamedplus
set cursorline
set ignorecase
set laststatus=0
set mouse=a
set noswapfile
set scrollback=100000
set termguicolors
set virtualedit=all

let mapleader = " "
map <silent> <leader>U :set nu! rnu!<cr>

map <silent> <esc> :nohlsearch<cr>
map <silent> <leader>c y
map <silent> <leader>q :qa!<CR>
map <silent> q :qa!<CR>

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
