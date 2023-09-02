set ignorecase
set noshowmode
set notimeout ttimeout ttimeoutlen=0
set smartcase

augroup highlightYank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup="IncSearch", timeout=150, on_macro=true }
augroup end

function! VSCodeNotifyVisual(cmd, leaveSelection, ...)
  let mode = mode()
  if mode ==# 'V'
    let startLine = line('v')
    let endLine = line('.')
    call VSCodeNotifyRange(a:cmd, startLine, endLine, a:leaveSelection, a:000)
  elseif mode ==# 'v' || mode ==# "\<C-v>"
    let startPos = getpos('v')
    let endPos = getpos('.')
    call VSCodeNotifyRangePos(a:cmd, startPos[1], endPos[1], startPos[2], endPos[2] + 1, a:leaveSelection, a:000)
  else
    call VSCodeNotify(a:cmd, a:000)
  endif
endfunction

nnoremap <unique> <silent> <Space><Tab> <Cmd>call VSCodeNotify('clangd.switchheadersource')<CR>
nnoremap <unique> <silent> <Space>B <Cmd>call VSCodeNotify('editor.action.toggleMinimap')<CR>
nnoremap <unique> <silent> <Space>E <Cmd>call VSCodeNotifyVisual('editor.action.sortLinesDescending', 1)<CR><ESC>
nnoremap <unique> <silent> <Space>R <Cmd>call VSCodeNotify('clangd.restart')<CR>
nnoremap <unique> <silent> <Space>c <Cmd>call VSCodeNotify('editor.action.clipboardCopyAction')<CR><ESC>
nnoremap <unique> <silent> <Space>e <Cmd>call VSCodeNotifyVisual('editor.action.sortLinesAscending', 1)<CR><ESC>
nnoremap <unique> <silent> <Space>g <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
nnoremap <unique> <silent> <Space>o <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <unique> <silent> <Space>r <Cmd>call VSCodeNotify('editor.action.rename')<CR>
nnoremap <unique> <silent> <Space>v <Cmd>call VSCodeNotify('editor.action.clipboardPasteAction')<CR>
nnoremap <unique> <silent> <Space>z <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
xnoremap <unique> <silent> <Space>E <Cmd>call VSCodeNotifyVisual('editor.action.sortLinesDescending', 1)<CR><ESC>
xnoremap <unique> <silent> <Space>c <Cmd>call VSCodeNotifyVisual('editor.action.clipboardCopyAction', 1)<CR><ESC>
xnoremap <unique> <silent> <Space>e <Cmd>call VSCodeNotifyVisual('editor.action.sortLinesAscending', 1)<CR><ESC>
xnoremap <unique> <silent> <Space>v <Cmd>call VSCodeNotifyVisual('editor.action.clipboardPasteAction', 1)<CR><ESC>

nnoremap <unique> <silent> <Space>' <Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>
nnoremap <unique> <silent> <Space>- <Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>
nnoremap <unique> <silent> <Space><Space> <Cmd>call VSCodeNotify('workbench.action.quickOpenPreviousRecentlyUsedEditor')<CR> \| <Cmd>call VSCodeNotify('workbench.action.acceptSelectedQuickOpenItem')<CR>
nnoremap <unique> <silent> <Space>= <Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>
nnoremap <unique> <silent> <Space>\ <Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>

nnoremap <unique> <silent> <Space>0 <Cmd>call VSCodeNotify('workbench.action.lastEditorInGroup')<CR>
nnoremap <unique> <silent> <Space>1 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex1')<CR>
nnoremap <unique> <silent> <Space>2 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex2')<CR>
nnoremap <unique> <silent> <Space>3 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex3')<CR>
nnoremap <unique> <silent> <Space>4 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex4')<CR>
nnoremap <unique> <silent> <Space>5 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex5')<CR>
nnoremap <unique> <silent> <Space>6 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex6')<CR>
nnoremap <unique> <silent> <Space>7 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex7')<CR>
nnoremap <unique> <silent> <Space>8 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex8')<CR>
nnoremap <unique> <silent> <Space>9 <Cmd>call VSCodeNotify('workbench.action.openEditorAtIndex9')<CR>

nnoremap <unique> <silent> <Space>A <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
nnoremap <unique> <silent> <Space>D <Cmd>call VSCodeNotify('workbench.view.debug')<CR>
nnoremap <unique> <silent> <Space>G <Cmd>call VSCodeNotify('workbench.view.scm')<CR>
nnoremap <unique> <silent> <Space>a <Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>
nnoremap <unique> <silent> <Space>i <Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>
nnoremap <unique> <silent> <Space>n <Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>
nnoremap <unique> <silent> <Space>p <Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>
nnoremap <unique> <silent> <Space>q <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <unique> <silent> <Space>s <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <unique> <silent> <Space>w <Cmd>call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <unique> <silent> <Space>x <Cmd>call VSCodeNotify('workbench.action.files.saveFiles')<CR>
vnoremap <unique> <silent> <Space>a <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>

nnoremap <unique> <silent> <Space>; <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
nnoremap <unique> <silent> <Space>U <Cmd>call VSCodeNotify('settings.cycle.lineNumbers')<CR>
nnoremap <unique> <silent> <Space>b <Cmd>call VSCodeNotify('workbench.action.toggleStatusbarVisibility')<CR>
nnoremap <unique> <silent> <Space>d <Cmd>call VSCodeNotify('workbench.action.toggleActivityBarVisibility')<CR>
nnoremap <unique> <silent> <Space>f <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>
nnoremap <unique> <silent> <Space>m <Cmd>call VSCodeNotify('workbench.action.toggleMenuBar')<CR>
nnoremap <unique> <silent> <Space>t <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>
nnoremap <unique> <silent> <Space>u <Cmd>call VSCodeNotify('workbench.action.toggleTabsVisibility')<CR>
nnoremap <unique> <silent> <Space>y <Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>
vnoremap <unique> <silent> <Space>; <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

nnoremap <unique> <silent> <Space>H <Cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupLeft')<CR>
nnoremap <unique> <silent> <Space>J <Cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupDown')<CR>
nnoremap <unique> <silent> <Space>K <Cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupUp')<CR>
nnoremap <unique> <silent> <Space>L <Cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupRight')<CR>
nnoremap <unique> <silent> <Space>h <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <unique> <silent> <Space>j <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <unique> <silent> <Space>k <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <unique> <silent> <Space>l <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>

nnoremap <unique> <silent><C-j> <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nnoremap <unique> <silent><C-k> <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>

nnoremap <silent><C-l> <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
nnoremap <unique> <silent><C-h> <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>

nnoremap <unique> <silent>gc <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
nnoremap <unique> <silent>gi <Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
nnoremap <unique> <silent>gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
vnoremap <unique> <silent>gc <ESC><Cmd>call VSCodeNotifyVisual('editor.action.blockComment', 1)<CR><ESC>

nnoremap <unique> <silent> <Space>C gg"+yG
vnoremap <unique> <silent> <Space>p p

nnoremap <unique> <silent> <Esc> :nohlsearch<cr>
nnoremap <unique> <silent> j gj
nnoremap <unique> <silent> k gk
vnoremap <unique> <silent> < <gv
vnoremap <unique> <silent> > >gv
vnoremap <unique> <silent> j gj
vnoremap <unique> <silent> k gk
vnoremap <unique> <silent> p "_dP
