vim.o.autoindent = true
vim.o.backup = false
vim.o.belloff = "all"
vim.o.breakindent = true
vim.o.cindent = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.ff = "unix"
vim.o.foldlevelstart = 99
vim.o.foldmethod = "indent"
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.joinspaces = false
vim.o.laststatus = 2
vim.o.lazyredraw = true
vim.o.linebreak = true
vim.o.list = true
vim.o.makeprg = "make -j4 -w"
vim.o.mouse = "a"
vim.o.number = true
vim.o.path = "$PWD/**"
vim.o.pumheight = 15
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 0
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.showmatch = true
vim.o.showmode = false
vim.o.sidescroll = 0
vim.o.sidescrolloff = 0
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.spellcapcheck = ""
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeout = false
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.virtualedit = "block"
vim.o.wildignorecase = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.wrap = false

vim.opt.complete:append("kspell")
vim.opt.completeopt = { "fuzzy", "menuone", "noinsert", "preview" }
vim.opt.diffopt:append("foldcolumn:0")
vim.opt.directory:append(".")
vim.opt.isfname:append("@-@")
vim.opt.listchars:append("tab:  ,extends:>,precedes:<,trail:·,nbsp:⎵")
vim.opt.shortmess:append("c")
vim.opt.suffixes:remove(".h")
vim.opt.wildignore:append(
  "*.o,*.rej,*.so,.cache/*,.clangd/*,.venv/*,build/*,node_modules/*,vendor/*,package-lock.json,yarn.lock"
)

if vim.fn.filereadable("/usr/local/bin/python3") == 1 then
  vim.g.python3_host_prog = "/usr/local/bin/python3"
end

vim.g.skip_ts_context_commenstring_module = true
vim.g.undotree_HighlightChangedText = 0
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_WindowLayout = 2
