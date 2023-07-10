local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "jose-elias-alvarez/nvim-lsp-ts-utils" },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "mfussenegger/nvim-dap" },
  { "mfussenegger/nvim-jdtls" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "nvim-telescope/telescope-dap.nvim" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
  { "rcarriga/nvim-dap-ui" },
  { "theHamsta/nvim-dap-virtual-text" },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        config = function()
          require("plugins.lsp")
        end,
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("plugins.fidget")
        end,
        tag = "legacy",
      },
    },
  },
  {
    "folke/neodev.nvim",
    ft = "lua",
    config = function()
      require("neodev").setup()
    end,
  },
  {
    "kostiskalkounos/onedark",
    event = "BufEnter",
    dependencies = {
      "nvim-lualine/lualine.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.cmd("colorscheme onedark")
      require("plugins.lualine")
      require("nvim-web-devicons").setup()
    end,
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    config = function()
      require("plugins.neogit")
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").init()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("plugins.colorizer")
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "InsertEnter",
    keys = { "gc", "gb", "gcc", "gbc", "v", "V", "<C-v>" },
    config = function()
      require("plugins.comment")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    build = ":TSUpdate",
    config = function()
      require("plugins.treesitter")
      require("plugins.context")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
      { "windwp/nvim-autopairs" },
    },
    config = function()
      require("plugins.cmp")
    end,
  },
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("plugins.tree")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("plugins.telescope")
    end,
  },
}

local options = {
  defaults = { lazy = true },
  checker = { enabled = false },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  debug = false,
}

require("lazy").setup(plugins, options)
