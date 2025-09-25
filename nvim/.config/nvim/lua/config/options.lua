local g = vim.g
local o = vim.o
local opt = vim.opt

o.autoindent = true
o.backup = false
o.belloff = "all"
o.breakindent = true
o.cindent = true
o.cursorline = true
o.expandtab = true
o.ff = "unix"
o.foldlevelstart = 99
o.foldmethod = "indent"
o.hidden = true
o.ignorecase = true
o.inccommand = "split"
o.joinspaces = false
o.laststatus = 2
o.lazyredraw = true
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

opt.complete:append("kspell")
opt.completeopt = { "fuzzy", "menuone", "noinsert", "preview" }
opt.diffopt:append("foldcolumn:0")
opt.directory:append(".")
opt.isfname:append("@-@")
opt.listchars:append("tab:  ,extends:>,precedes:<,trail:·,nbsp:⎵")
opt.path:append("**")
opt.shortmess:append("c")
opt.suffixes:remove(".h")
opt.wildignore:append("*.o,*.rej,*.so,.cache/*,.clangd/*,.venv/*,node_modules/*,package-lock.json,yarn.lock")

if vim.fn.filereadable("/usr/local/bin/python3") == 1 then
  g.python3_host_prog = "/usr/local/bin/python3"
end

g.skip_ts_context_commenstring_module = true
g.undotree_HighlightChangedText = 0
g.undotree_SetFocusWhenToggle = 1
g.undotree_WindowLayout = 2
