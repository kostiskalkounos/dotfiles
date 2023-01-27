local packer = require("util.packer")

local config = {
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "none" })
    end,
  },
}

local function plugins(use)
  use({ "JoosepAlviste/nvim-ts-context-commentstring", module = "ts_context_commentstring" })
  use({ "mbbill/undotree", cmd = "UndotreeToggle" })
  use({ "nvim-lua/plenary.nvim", module = "plenary" })
  use({ "nvim-lua/popup.nvim", module = "popup" })
  use({ "wbthomason/packer.nvim", opt = true })

  use("mfussenegger/nvim-dap")
  use("mfussenegger/nvim-jdtls")
  use("nvim-telescope/telescope-dap.nvim")
  use("rcarriga/nvim-dap-ui")
  use("theHamsta/nvim-dap-virtual-text")

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
    "nvim-tree/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
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

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "nvim-treesitter/nvim-treesitter-context",
      { "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
      { "nvim-treesitter/playground", opt = true, cmd = "TSHighlightCapturesUnderCursor" },
    },
    config = function()
      require("config.treesitter")
      require("config.context")
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.cmp")
    end,
  })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-path" })
  use({ "onsails/lspkind-nvim" })
  use({ "saadparwaiz1/cmp_luasnip" })
  use({ "L3MON4D3/LuaSnip" })
  use({
    "rafamadriz/friendly-snippets",
    module = "nvim-autopairs",
    "windwp/nvim-autopairs",
    config = function()
      require("config.snippets")
      require("config.autopairs")
    end,
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
    "nvim-tree/nvim-tree.lua",
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
    },
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
  })
end

return packer.setup(config, plugins)
