if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plugInstall
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup end
endif

call plug#begin('~/.vim/plugged')
  Plug 'joshdick/onedark.vim'
  Plug 'jremmen/vim-ripgrep'
  Plug 'junegunn/fzf.vim'
  Plug 'mbbill/undotree'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-fugitive'
call plug#end()

colorscheme onedark
filetype plugin indent on
set autoindent
set autoread
set backspace=indent,eol,start
set complete+=kspell
set completeopt=menuone,preview,noinsert
set cursorline
set expandtab
set ff=unix
set foldlevelstart=99
set foldmethod=indent
set hidden
set hlsearch
set ignorecase
set incsearch
set isfname+=@-@
set laststatus=2
set lazyredraw
set list
set listchars=tab:➝\ ,extends:>,precedes:<,nbsp:⎵
set makeprg=make\ -j4\ -w
set mouse=a
set nobackup
set nocompatible
set nojoinspaces
set nostartofline
set noswapfile
set notimeout ttimeout ttimeoutlen=0
set nowrap
set nowritebackup
set number relativenumber
set path=$PWD/**
set rtp+=/usr/local/opt/fzf
set ruler
set shiftwidth=2
set shortmess+=c
set showcmd
set showmatch
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set termguicolors
set ttyfast
set undodir=~/.vim/undodir
set undofile
set updatetime=300
set visualbell t_vb=
set wildignore+=.cache/*,.clangd/*,build/*,node_modules/*,vendor/*,package-lock.json,yarn.lock
set wildignorecase
set wildmenu
set wildmode=longest:full,full
syntax on

let g:coc_global_extensions=[
  \'coc-clangd',
  \'coc-css',
  \'coc-eslint',
  \'coc-html',
  \'coc-json',
  \'coc-marketplace',
  \'coc-pairs',
  \'coc-prettier',
  \'coc-pyright',
  \'coc-sh',
  \'coc-tsserver',
\]

let c_no_curly_error = 1
let g:cpp_simple_highlight = 1
let g:fzf_layout = {'window': {'width': 0.8, 'height': 0.8, 'highlight': 'Todo', 'border': 'sharp'}}
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_liststyle = 0
let g:netrw_winsize = 25
let g:python_highlight_all = 1
let g:undotree_HighlightChangedText = 0
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let mapleader = "\<Space>"

execute "set <M-0>=\e0"
execute "set <M-1>=\e1"
execute "set <M-2>=\e2"
execute "set <M-3>=\e3"
execute "set <M-4>=\e4"
execute "set <M-5>=\e5"
execute "set <M-6>=\e6"
execute "set <M-7>=\e7"
execute "set <M-8>=\e8"
execute "set <M-9>=\e9"
execute "set <M-S-H>=\eH"
execute "set <M-S-J>=\eJ"
execute "set <M-S-K>=\eK"
execute "set <M-S-L>=\eL"
execute "set <M-a>=\ea"
execute "set <M-b>=\eb"
execute "set <M-c>=\ec"
execute "set <M-d>=\ed"
execute "set <M-e>=\ee"
execute "set <M-f>=\ef"
execute "set <M-g>=\eg"
execute "set <M-h>=\eh"
execute "set <M-i>=\ei"
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-l>=\el"
execute "set <M-m>=\em"
execute "set <M-n>=\en"
execute "set <M-o>=\eo"
execute "set <M-p>=\ep"
execute "set <M-q>=\eq"
execute "set <M-r>=\er"
execute "set <M-s>=\es"
execute "set <M-t>=\et"
execute "set <M-u>=\eu"
execute "set <M-v>=\ev"
execute "set <M-w>=\ew"
execute "set <M-x>=\ex"
execute "set <M-y>=\ey"
execute "set <M-z>=\ez"

let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
let &t_EI.= "\e[2 q"
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SI.= "\e[6 q"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_SR.= "\e[4 q"

cnoremap <unique> <C-a> <Home>
cnoremap <unique> <C-b> <Left>
cnoremap <unique> <C-e> <End>
cnoremap <unique> <C-f> <Right>
cnoremap <unique> <C-h> <Left>
cnoremap <unique> <C-j> <Down>
cnoremap <unique> <C-k> <Up>
cnoremap <unique> <C-l> <Right>
cnoremap <unique> <C-n> <Down>
cnoremap <unique> <C-p> <Up>
cnoremap <unique> <M-b> <S-Left>
cnoremap <unique> <M-f> <S-Right>
cnoremap <unique> <M-h> <Left>
cnoremap <unique> <M-j> <Down>
cnoremap <unique> <M-k> <Up>
cnoremap <unique> <M-l> <Right>
cnoremap <unique> <M-n> <Down>
cnoremap <unique> <M-p> <Up>
tnoremap <unique> <silent> <C-\><C-\> <C-\><C-N>

inoremap <unique> <silent> <C-h> <Left>
inoremap <unique> <silent> <C-j> <Down>
inoremap <unique> <silent> <C-k> <Up>
inoremap <unique> <silent> <C-l> <Right>
inoremap <unique> <silent> <M-a> <C-a>
inoremap <unique> <silent> <M-b> <C-b>
inoremap <unique> <silent> <M-c> <C-c>
inoremap <unique> <silent> <M-d> <C-d>
inoremap <unique> <silent> <M-e> <C-e>
inoremap <unique> <silent> <M-f> <C-f>
inoremap <unique> <silent> <M-g> <C-g>
inoremap <unique> <silent> <M-h> <Left>
inoremap <unique> <silent> <M-i> <C-i>
inoremap <unique> <silent> <M-j> <Down>
inoremap <unique> <silent> <M-k> <Up>
inoremap <unique> <silent> <M-l> <Right>
inoremap <unique> <silent> <M-m> <C-m>
inoremap <unique> <silent> <M-n> <C-n>
inoremap <unique> <silent> <M-o> <C-o>
inoremap <unique> <silent> <M-p> <C-p>
inoremap <unique> <silent> <M-q> <C-q>
inoremap <unique> <silent> <M-r> <C-r>
inoremap <unique> <silent> <M-s> <C-s>
inoremap <unique> <silent> <M-t> <C-t>
inoremap <unique> <silent> <M-u> <C-u>
inoremap <unique> <silent> <M-v> <C-v>
inoremap <unique> <silent> <M-w> <C-w>
inoremap <unique> <silent> <M-x> <C-x>
inoremap <unique> <silent> <M-y> <C-y>
inoremap <unique> <silent> <M-z> <C-z>

nmap <unique> <silent> <M-6> <leader><leader>
nnoremap <unique> <silent> <C-h> <Left>
nnoremap <unique> <silent> <C-j> <Down>
nnoremap <unique> <silent> <C-k> <Up>
nnoremap <unique> <silent> <C-l> <Right>
nnoremap <unique> <silent> <M-a> <C-a>
nnoremap <unique> <silent> <M-b> <C-b>
nnoremap <unique> <silent> <M-c> <C-c>
nnoremap <unique> <silent> <M-d> <C-d>
nnoremap <unique> <silent> <M-e> <C-e>
nnoremap <unique> <silent> <M-f> <C-f>
nnoremap <unique> <silent> <M-g> <C-g>
nnoremap <unique> <silent> <M-h> :vertical resize -2<CR>
nnoremap <unique> <silent> <M-i> <C-i>
nnoremap <unique> <silent> <M-j> :resize -2<CR>
nnoremap <unique> <silent> <M-k> :resize +2<CR>
nnoremap <unique> <silent> <M-l> :vertical resize +2<CR>
nnoremap <unique> <silent> <M-m> <C-m>
nnoremap <unique> <silent> <M-n> <C-n>
nnoremap <unique> <silent> <M-o> <C-o>
nnoremap <unique> <silent> <M-p> <C-p>
nnoremap <unique> <silent> <M-q> <C-q>
nnoremap <unique> <silent> <M-r> <C-r>
nnoremap <unique> <silent> <M-s> <C-s>
nnoremap <unique> <silent> <M-t> <C-t>
nnoremap <unique> <silent> <M-u> <C-u>
nnoremap <unique> <silent> <M-v> <C-v>
nnoremap <unique> <silent> <M-w> <C-w>
nnoremap <unique> <silent> <M-x> <C-x>
nnoremap <unique> <silent> <M-y> <C-y>
nnoremap <unique> <silent> <M-z> <C-z>

vnoremap <unique> <silent> <C-h> <Left>
vnoremap <unique> <silent> <C-j> <Down>
vnoremap <unique> <silent> <C-k> <Up>
vnoremap <unique> <silent> <C-l> <Right>
vnoremap <unique> <silent> <M-a> <C-a>
vnoremap <unique> <silent> <M-b> <C-b>
vnoremap <unique> <silent> <M-c> <C-c>
vnoremap <unique> <silent> <M-d> <C-d>
vnoremap <unique> <silent> <M-e> <C-e>
vnoremap <unique> <silent> <M-f> <C-f>
vnoremap <unique> <silent> <M-g> <C-g>
vnoremap <unique> <silent> <M-h> <C-h>
vnoremap <unique> <silent> <M-i> <C-i>
vnoremap <unique> <silent> <M-j> :move '>+1<CR>gv=gv
vnoremap <unique> <silent> <M-k> :move '<-2<CR>gv=gv
vnoremap <unique> <silent> <M-l> <C-l>
vnoremap <unique> <silent> <M-m> <C-m>
vnoremap <unique> <silent> <M-n> <C-n>
vnoremap <unique> <silent> <M-o> <C-o>
vnoremap <unique> <silent> <M-p> <C-p>
vnoremap <unique> <silent> <M-q> <C-q>
vnoremap <unique> <silent> <M-r> <C-r>
vnoremap <unique> <silent> <M-s> <C-s>
vnoremap <unique> <silent> <M-t> <C-t>
vnoremap <unique> <silent> <M-u> <C-u>
vnoremap <unique> <silent> <M-v> <C-v>
vnoremap <unique> <silent> <M-w> <C-w>
vnoremap <unique> <silent> <M-x> <C-x>
vnoremap <unique> <silent> <M-y> <C-y>
vnoremap <unique> <silent> <M-z> <C-z>

nnoremap <unique> <silent> [b :bp<CR>
nnoremap <unique> <silent> [c :cp<CR>
nnoremap <unique> <silent> [l :lp<CR>
nnoremap <unique> <silent> [t :tabp<CR>
nnoremap <unique> <silent> ]b :bn<CR>
nnoremap <unique> <silent> ]c :cn<CR>
nnoremap <unique> <silent> ]l :ln<CR>
nnoremap <unique> <silent> ]t :tabn<CR>

inoremap <unique> <space> <space><c-g>u
nnoremap <unique> <silent> Y y$
nnoremap <unique> <silent> j gj
nnoremap <unique> <silent> k gk
vnoremap <unique> <silent> < <gv
vnoremap <unique> <silent> > >gv
vnoremap <unique> <silent> j gj
vnoremap <unique> <silent> k gk
vnoremap <unique> <silent> p "_dP

nnoremap <unique> <silent> <leader>0 :tabl<cr>
nnoremap <unique> <silent> <leader>1 1gt
nnoremap <unique> <silent> <leader>2 2gt
nnoremap <unique> <silent> <leader>3 3gt
nnoremap <unique> <silent> <leader>4 4gt
nnoremap <unique> <silent> <leader>5 5gt
nnoremap <unique> <silent> <leader>6 6gt
nnoremap <unique> <silent> <leader>7 7gt
nnoremap <unique> <silent> <leader>8 8gt
nnoremap <unique> <silent> <leader>9 9gt

nnoremap <unique> <silent> <leader>H <C-w>H
nnoremap <unique> <silent> <leader>J <C-w>J
nnoremap <unique> <silent> <leader>K <C-w>K
nnoremap <unique> <silent> <leader>L <C-w>L
nnoremap <unique> <silent> <leader>h <C-w>h
nnoremap <unique> <silent> <leader>j <C-w>j
nnoremap <unique> <silent> <leader>k <C-w>k
nnoremap <unique> <silent> <leader>l <C-w>l

nnoremap <unique> <leader>A :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <unique> <leader>D :diffget //2<CR>
nnoremap <unique> <leader>F :diffget //3<CR>
nnoremap <unique> <leader>G :G<CR>
nnoremap <unique> <leader>I :buffers<CR>:buffer<Space>
nnoremap <unique> <leader>M :CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <unique> <leader>O :h <C-R>=expand("<cword>")<CR><CR>
nnoremap <unique> <leader>R :CocRestart<CR><CR>
nnoremap <unique> <leader>S :GFiles<CR>
nnoremap <unique> <leader>V :set paste!<CR>
nnoremap <unique> <leader>a :Ripgrep<SPACE>
nnoremap <unique> <leader>d :Rg<SPACE>
nnoremap <unique> <leader>i :Buffers<CR>
nnoremap <unique> <leader>m :CocSearch<SPACE>
nnoremap <unique> <leader>s :Files<CR>
nnoremap <unique> <silent> <Leader>n :bn<CR>
nnoremap <unique> <silent> <Leader>p :bp<CR>
nnoremap <unique> <silent> <leader><leader> <C-^>
nnoremap <unique> <silent> <leader><Tab> :CocCommand clangd.switchSourceHeader<CR>
nnoremap <unique> <silent> <leader>T :vert terminal<CR>
nnoremap <unique> <silent> <leader>Y :<C-u>CocListResume<CR>
nnoremap <unique> <silent> <leader>f :call <SID>ToggleNetrw()<CR>
nnoremap <unique> <silent> <leader>o :setlocal spell! spelllang=en_us<CR>
nnoremap <unique> <silent> <leader>q :q<CR>
nnoremap <unique> <silent> <leader>t :terminal<CR>
nnoremap <unique> <silent> <leader>u :UndotreeShow<CR>
nnoremap <unique> <silent> <leader>w :w<CR>
nnoremap <unique> <silent> <leader>x :x<CR>
nnoremap <unique> <silent> <leader>y :<C-u>CocList diagnostics<cr>
nnoremap <unique> <silent> <leader>z :nohlsearch<cr>
vnoremap <unique> <silent> <leader>p "_dP

nnoremap <unique> <silent> <leader>E vip:sort iu<CR>
nnoremap <unique> <silent> <leader>e vip:sort u<CR>
vnoremap <unique> <silent> <leader>E :sort iu<CR>
vnoremap <unique> <silent> <leader>e :sort u<CR>

nnoremap <unique> <silent> <leader>' :vsp<CR>
nnoremap <unique> <silent> <leader>- :sp<CR>
nnoremap <unique> <silent> <leader>= :sp<CR>
nnoremap <unique> <silent> <leader>\ :vsp<CR>

nnoremap <unique> <silent> <leader>C gg"+yG
nnoremap <unique> <silent> <leader>c "+y
nnoremap <unique> <silent> <leader>v "+p
vnoremap <unique> <silent> <leader>c "+y
vnoremap <unique> <silent> <leader>d "_d
vnoremap <unique> <silent> <leader>v "+p

nmap <unique> <leader>B <Plug>(coc-codeaction)
nmap <unique> <leader>b <Plug>(coc-codeaction-selected)
nmap <unique> <leader>g <Plug>(coc-fix-current)
nmap <unique> <leader>r <Plug>(coc-rename)
xmap <unique> <leader>b <Plug>(coc-codeaction-selected)

nmap <unique> <silent> [g <Plug>(coc-diagnostic-prev)
nmap <unique> <silent> ]g <Plug>(coc-diagnostic-next)
nmap <unique> <silent> gd <Plug>(coc-definition)
nmap <unique> <silent> gi <Plug>(coc-implementation)
nmap <unique> <silent> gr <Plug>(coc-references)
nmap <unique> <silent> gy <Plug>(coc-type-definition)
nnoremap <unique> <silent> K :call <SID>show_documentation()<CR>

inoremap <unique> <silent><expr> <TAB>
     \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <unique> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <unique> <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <unique> <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <unique> <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
nnoremap <unique> <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
nnoremap <unique> <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
vnoremap <unique> <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
vnoremap <unique> <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"

let g:netrwIsOpen = 0
fun! s:ToggleNetrw()
    if g:netrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:netrwIsOpen=0
    else
        let g:netrwIsOpen=1
        silent Vexplore
    endif
endfun

fun! s:RipgrepFzf(query, fullscreen)
  let command_fmt = "rg --column --line-number --no-heading --color=always --smart-case -g '!{.git,.cache,.clangd,android,ios,build,node_modules,vendor,package-lock.json,yarn.lock}' -- %s || true"
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfun

fun! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfun

fun! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfun

augroup trimWhiteSpace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup end

augroup signatureHelp
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

command! -nargs=* -bang Ripgrep call <SID>RipgrepFzf(<q-args>, <bang>0)
command! -nargs=0 Format :call <SID>CocAction('format')
command! -nargs=0 OR :call <SID>CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=? Fold :call <SID>CocAction('fold', <f-args>)
