GuiFont! Consolas:h13
GuiPopupmenu 0
GuiTabline 0

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
hi Normal guifg=#abb2bf ctermfg=NONE guibg=#1f2329 ctermbg=NONE gui=NONE cterm=NONE

nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
