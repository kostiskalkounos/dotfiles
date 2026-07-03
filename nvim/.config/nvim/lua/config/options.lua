local g = vim.g
local o = vim.o

o.autoindent = true
o.backup = false
o.belloff = "all"
o.breakindent = true
o.cindent = true
o.cursorline = true
o.expandtab = true
o.ff = "unix"
o.fillchars = "eob: "
o.foldlevelstart = 99
o.foldmethod = "manual"
o.hidden = true
o.ignorecase = true
o.inccommand = "split"
o.joinspaces = false
o.laststatus = 3
o.linebreak = true
o.list = true
o.makeprg = "make -j4 -w"
o.mouse = "a"
o.number = true
o.pumheight = 15
o.relativenumber = true
o.ruler = false
o.scrolloff = 0
o.shiftround = true
o.shiftwidth = 2
o.showcmd = false
o.showmatch = true
o.showmode = false
o.sidescroll = 0
o.sidescrolloff = 0
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.smarttab = true
o.softtabstop = 2
o.spellcapcheck = ""
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 2
o.termguicolors = true
o.timeout = false
o.undofile = true
o.updatetime = 300
o.virtualedit = "block"
o.wildignorecase = true
o.wildmenu = true
o.wildmode = "longest:full,full"
o.wrap = false

o.complete = ".,w,b"
o.completeopt = "fuzzy,menuone,noinsert,preview"
o.shada = "!,'100,<50,s10,h"
o.diffopt = "internal,filler,closeoff,linematch:60,foldcolumn:0"
o.directory = o.directory .. ",."
if not o.isfname:find("@-@", 1, true) then
  o.isfname = o.isfname .. ",@-@"
end
o.listchars = "tab:  ,extends:>,precedes:<,trail:·,nbsp:⎵"
if not o.shortmess:find("c", 1, true) then
  o.shortmess = o.shortmess .. "c"
end
o.suffixes = o.suffixes:gsub("%.h", ""):gsub(",,", ",")
o.wildignore = o.wildignore .. ",*.o,*.rej,*.so,.cache/*,.clangd/*,.venv/*,node_modules/*,package-lock.json,yarn.lock"

g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0

g.loaded_2html_plugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_gzip = 1
g.loaded_logiPat = 1
g.loaded_netrw = 1
g.loaded_netrwFileHandlers = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_remote_plugins = 1
g.loaded_rrhelper = 1
g.loaded_spellfile_plugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_tohtml = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1

g.undotree_HighlightChangedText = 0
g.undotree_SetFocusWhenToggle = 1
g.undotree_WindowLayout = 2

local nvim_theme = os.getenv("NVIM_THEME")
if nvim_theme == "dark" or nvim_theme == "light" then
  o.background = nvim_theme
end
