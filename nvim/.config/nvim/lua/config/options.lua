vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.belloff = "all"
vim.opt.breakindent = true
vim.opt.cindent = true
vim.opt.complete:append("kspell")
vim.opt.completeopt = { "menuone", "noinsert", "preview" }
vim.opt.cursorline = true
vim.opt.diffopt:append("foldcolumn:0")
vim.opt.directory:append(".")
vim.opt.expandtab = true
vim.opt.ff = "unix"
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.isfname:append("@-@")
vim.opt.joinspaces = false
vim.opt.laststatus = 2
vim.opt.lazyredraw = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars:append("tab:  ,extends:>,precedes:<,trail:·,nbsp:⎵")
vim.opt.makeprg = "make -j4 -w"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.path = "$PWD/**"
vim.opt.pumheight = 15
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 0
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append("c")
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.sidescroll = 0
vim.opt.sidescrolloff = 0
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.spellcapcheck = ""
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.suffixes:remove(".h")
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeout = false
vim.opt.ttimeout = false
vim.opt.ttimeoutlen = 0
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.virtualedit = "block"
vim.opt.wildignore:append(
  "*.o,*.rej,*.so,.cache/*,.clangd/*,.venv/*,build/*,node_modules/*,vendor/*,package-lock.json,yarn.lock"
)
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = false

if vim.fn.filereadable("/usr/local/bin/python3") == 1 then
  vim.g.python3_host_prog = "/usr/local/bin/python3"
end

vim.g.undotree_HighlightChangedText = 0
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_WindowLayout = 2

local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")
