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
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true, module = "ts_context_commentstring" },
  { "jose-elias-alvarez/null-ls.nvim", lazy = true },
  { "jose-elias-alvarez/nvim-lsp-ts-utils", lazy = true },
  { "mbbill/undotree", cmd = "UndotreeToggle", lazy = true },
  { "mfussenegger/nvim-dap", lazy = true },
  { "mfussenegger/nvim-jdtls", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true, module = "plenary" },
  { "nvim-lua/popup.nvim", lazy = true, module = "popup" },
  { "nvim-telescope/telescope-dap.nvim", lazy = true },
  { "nvim-treesitter/nvim-treesitter-context", lazy = true },
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
  { "nvim-treesitter/playground", lazy = true, cmd = "TSHighlightCapturesUnderCursor" },
  { "rcarriga/nvim-dap-ui", lazy = true },
  { "theHamsta/nvim-dap-virtual-text", lazy = true },

  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "neovim/nvim-lspconfig",
        lazy = true,
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
    "simrat39/inlay-hints.nvim",
    lazy = true,
    config = function()
      require("plugins.inlay")
    end,
  },

  {
    "folke/neodev.nvim",
    lazy = true,
    config = function()
      require("neodev").setup()
    end,
  },

  {
    "kostiskalkounos/onedark",
    config = function()
      vim.api.nvim_command("colorscheme onedark")
    end,
  },

  {
    "nathom/filetype.nvim",
    lazy = true,
    config = function()
      require("plugins.filetype")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    module = "nvim-web-devicons",
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
    module = "diffview",
    config = function()
      require("diffview").init()
    end,
    dependencies = "nvim-lua/plenary.nvim",
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
    keys = { "gc", "gb", "gcc", "gbc" },
    config = function()
      require("plugins.comment")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins.treesitter")
      require("plugins.context")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    keys = { "a", "c", "d", "i", "o", "v", "A", "C", "D", "I", "O", "V", "<C-v>" },
    config = function()
      require("plugins.cmp")
    end,
    dependencies = {
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "hrsh7th/cmp-path", lazy = true },
      { "saadparwaiz1/cmp_luasnip", lazy = true },
      { "L3MON4D3/LuaSnip", lazy = true },
      {
        "rafamadriz/friendly-snippets",
        lazy = true,
        module = "nvim-autopairs",
        "windwp/nvim-autopairs",
        config = function()
          require("plugins.autopairs")
        end,
      },
    },
  },

  {
    "windwp/nvim-spectre",
    lazy = true,
    module = "spectre",
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
    config = {
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      filters = {
        custom = { ".git", "node_modules" },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    config = function()
      require("plugins.telescope")
    end,
    cmd = { "Telescope" },
    module = "telescope",
    dependencies = {
      { "nvim-lua/popup.nvim", lazy = true },
      { "nvim-lua/plenary.nvim", lazy = true },
      { "nvim-telescope/telescope-fzy-native.nvim", lazy = true },
    },
  },
})
