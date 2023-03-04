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

require("lazy").setup({
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  { "jose-elias-alvarez/null-ls.nvim", lazy = true },
  { "jose-elias-alvarez/nvim-lsp-ts-utils", lazy = true },
  { "mbbill/undotree", cmd = "UndotreeToggle", lazy = true },
  { "mfussenegger/nvim-dap", lazy = true },
  { "mfussenegger/nvim-jdtls", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-lua/popup.nvim", lazy = true },
  { "nvim-telescope/telescope-dap.nvim", lazy = true },
  { "nvim-treesitter/nvim-treesitter-context", lazy = true },
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
  { "nvim-treesitter/playground", lazy = true, cmd = "TSHighlightCapturesUnderCursor" },
  { "rcarriga/nvim-dap-ui", lazy = true },
  { "theHamsta/nvim-dap-virtual-text", lazy = true },
  {
    "williamboman/mason.nvim",
    lazy = true,
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
      },
    },
  },
  {
    "folke/neodev.nvim",
    lazy = true,
    ft = "lua",
    config = function()
      require("neodev").setup()
    end,
  },
  {
    "kostiskalkounos/onedark",
    config = function()
      vim.cmd("colorscheme onedark")
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.lualine")
    end,
  },
  {
    "TimUntersberger/neogit",
    lazy = true,
    cmd = "Neogit",
    config = function()
      require("plugins.neogit")
    end,
  },
  {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").init()
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    lazy = true,
    event = "BufReadPre",
    config = function()
      require("plugins.colorizer")
    end,
  },
  {
    "numToStr/Comment.nvim",
    lazy = true,
    event = "InsertEnter",
    keys = { "gc", "gb", "gcc", "gbc", "v", "V", "<C-v>" },
    config = function()
      require("plugins.comment")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = "BufReadPre",
    build = ":TSUpdate",
    config = function()
      require("plugins.treesitter")
      require("plugins.context")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
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
    lazy = true,
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
    config = function()
      require("plugins.tree")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = { "Telescope" },
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    config = function()
      require("plugins.telescope")
    end,
  },
})
