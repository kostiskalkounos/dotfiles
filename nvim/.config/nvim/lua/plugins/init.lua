return {
  { "almo7aya/openingh.nvim", event = "VeryLazy" },
  { "MagicDuck/grug-far.nvim", event = "VeryLazy" },
  { "mbbill/undotree", event = "VeryLazy" },
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
