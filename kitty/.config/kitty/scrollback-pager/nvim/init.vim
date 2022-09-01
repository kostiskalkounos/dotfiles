set background=dark
set clipboard+=unnamedplus
set cursorline
set ignorecase
set laststatus=0
set mouse=a
set number
set relativenumber
set scrollback=100000
set termguicolors
set virtualedit=all

map <silent> <esc> :nohlsearch<cr>
map <silent> q :qa!<CR>

augroup highlight_yank
  autocmd!
  autocmd  TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=150, on_macro=true}
augroup END

augroup start_at_bottom
    autocmd!
    autocmd VimEnter * normal G
augroup END

augroup prevent_insert
    autocmd!
    autocmd TermEnter * stopinsert
augroup END

hi CursorLine guifg=NONE ctermfg=NONE guibg=#242931 ctermbg=235 gui=NONE cterm=NONE
hi CursorLineNr guifg=#abb2bf ctermfg=249 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi ErrorMsg guifg=#d9737b ctermfg=174 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi IncSearch guifg=#1f2329 ctermfg=235 guibg=#c27fd7 ctermbg=140 gui=NONE cterm=NONE
hi LineNr guifg=#4b5263 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi NonText guifg=#3b4048 ctermfg=238 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Search guifg=#1f2329 ctermfg=235 guibg=#68aee8 ctermbg=74 gui=NONE cterm=NONE
hi Visual guifg=NONE ctermfg=NONE guibg=#3e4452 ctermbg=238 gui=NONE cterm=NONE
