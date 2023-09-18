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
  { "folke/neodev.nvim", ft = "lua" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "mfussenegger/nvim-jdtls" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
  { "towolf/vim-helm", ft = "helm" },
  {
    "mfussenegger/nvim-dap",
    cmd = "DapContinue",
    dependencies = {
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "nvim-telescope/telescope-dap.nvim" },
    },
    config = function()
      require("plugins.dap")
    end,
  },
  { "leoluz/nvim-dap-go" },
  { "mfussenegger/nvim-dap-python" },
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
      {
        "lewis6991/gitsigns.nvim",
        config = function()
          require("gitsigns").setup()
        end,
      },
    },
  },
  {
    "kostiskalkounos/onedark",
    lazy = false,
    priority = 1000,
    dependencies = {
      "nvim-lualine/lualine.nvim",
    },
    config = function()
      vim.cmd("colorscheme onedark")
      require("plugins.lualine")
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    config = function()
      require("neogit").setup({
        kind = "split",
        signs = {
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
        integrations = { diffview = true },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
    dependencies = "nvim-lua/plenary.nvim",
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
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },

    config = function()
      require("plugins.treesitter")
      require("plugins.context")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "rafamadriz/friendly-snippets" },
      { "saadparwaiz1/cmp_luasnip" },
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
