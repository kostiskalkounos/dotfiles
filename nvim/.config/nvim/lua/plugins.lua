local packer = require("util.packer")

local config = {
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "none" })
    end,
  },
}

local function plugins(use)
  use({ "mbbill/undotree", cmd = "UndotreeToggle" })
  use({ "nvim-lua/plenary.nvim", module = "plenary" })
  use({ "nvim-lua/popup.nvim", module = "popup" })
  use({ "wbthomason/packer.nvim", opt = true })

  use({
    "kostiskalkounos/onedark",
    config = function()
      vim.api.nvim_command("colorscheme onedark")
    end,
  })

  use({
    "nathom/filetype.nvim",
    config = function()
      require("config.filetype")
    end,
  })

  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })

  use({
    "folke/trouble.nvim",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({
        auto_open = false,
        use_diagnostic_signs = true,
      })
    end,
  })

  use({
    "TimUntersberger/neogit",
    cmd = "Neogit",
    config = function()
      require("config.neogit")
    end,
  })

  use({
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    module = "diffview",
    config = function()
      require("diffview").setup()
    end,
    requires = "nvim-lua/plenary.nvim",
  })

  use({
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("config.colorizer")
    end,
  })

  use({
    "numToStr/Comment.nvim",
    opt = true,
    keys = { "gc", "gb", "gcc", "gbc" },
    config = function()
      require("config.comment")
    end,
  })

  use({ "JoosepAlviste/nvim-ts-context-commentstring", module = "ts_context_commentstring" })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    opt = true,
    event = "BufRead",
    requires = {
      { "nvim-treesitter/playground", opt = true, cmd = "TSHighlightCapturesUnderCursor" },
    },
    config = function()
      require("config.treesitter")
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require("config.cmp")
    end,
    wants = { "LuaSnip" },
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require("config.snippets")
        end,
      },
      "rafamadriz/friendly-snippets",
      {
        module = "nvim-autopairs",
        "windwp/nvim-autopairs",
        config = function()
          require("config.autopairs")
        end,
      },
    },
  })

  use({
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    wants = {
      "null-ls.nvim",
      "cmp-nvim-lsp",
      "nvim-lsp-installer",
    },
    config = function()
      require("config.lsp")
    end,
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "williamboman/nvim-lsp-installer",
    },
  })

  use({
    "windwp/nvim-spectre",
    opt = true,
    module = "spectre",
    wants = { "plenary.nvim", "popup.nvim" },
    requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  })

  use({
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    config = function()
      require("config.tree")
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    opt = true,
    config = function()
      require("config.telescope")
    end,
    cmd = { "Telescope" },
    module = "telescope",
    wants = {
      "plenary.nvim",
      "popup.nvim",
      "telescope-fzy-native.nvim",
      "trouble.nvim",
    },
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
  })
end

return packer.setup(config, plugins)
