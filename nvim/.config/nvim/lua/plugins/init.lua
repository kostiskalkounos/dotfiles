return {
  { "almo7aya/openingh.nvim", event = "VeryLazy" },
  { "MagicDuck/grug-far.nvim", event = "VeryLazy" },
  { "mbbill/undotree", event = "VeryLazy" },
  {
    "catgoose/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({
        options = {
          parsers = {
            css = true,
            css_fn = true,
            names = {
              enable = false,
            },
          },
        },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown" },
        code = {
          sign = false,
          width = "block",
          right_pad = 4,
          position = "right",
        },
        heading = {
          -- width = "block",
          sign = false,
        },
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "sindrets/diffview.nvim",
    },
    opts = {
      kind = "split",
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = { diffview = true },
    },
  },
  {
    "nvim-mini/mini.icons",
    event = "VeryLazy",
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = "nvim-mini/mini.icons",
    opts = {
      actions = { open_file = { resize_window = false } },
      update_focused_file = { enable = true, update_cwd = false },
      filters = { custom = { "^.git$", "^.npm$", "^.cache$", "^.venv$", "node_modules" } },
      view = {
        width = {
          min = 30,
          max = -1,
        },
      },
    },
    config = function(_, o)
      require("nvim-tree").setup(o)
    end,
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    init = function()
      local fn = vim.fn
      local uv = vim.uv
      if fn.argc() == 1 then
        local arg = fn.argv(0)
        local stat = uv.fs_stat(arg)
        if stat and stat.type == "directory" then
          require("lazy").load({ plugins = { "oil.nvim" } })
        end
      end
    end,
    opts = {},
  },
}
