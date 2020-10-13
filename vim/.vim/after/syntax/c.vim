" Taken from Vim's syntax/c.vim. See the vim-license.txt file for its license.
" --- BEGIN COPY ---
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2019 Nov 29
syn region cDefine start="^\s*\zs\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup,@Spell,cInferredType
" --- END COPY ---

syn match cCustomScope "::"
syn match cCustomClass "\w\+\s*::" contains=cCustomScope

syn match cInferredType /\k\+<*>/me=e-1
syn match cInferredType /\k\+\s\k/me=e-2
syn match cInferredType /\k\+&&\s\k/me=e-4
syn match cInferredType /\k\+\s&&\k/me=e-4
syn match cInferredType /\k\+[*&]\s\k/me=e-3
syn match cInferredType /\k\+\s[*&]\k/me=e-3
syn match cInferredType /\k\+\*\*\s\k/me=e-4
syn match cInferredType /\k\+\s\*\*\k/me=e-4

hi def link cInferredType Type
hi def link cCustomClass Constant
hi def link cppSTLvariable Function
