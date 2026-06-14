return {
  { "almo7aya/openingh.nvim", cmd = { "OpenInGHFileLines", "OpenInGHFile", "OpenInGHRepo" } },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    init = function()
      if vim.fn.argc() == 1 then
        local arg = vim.fn.argv(0)
        local stat = vim.uv.fs_stat(arg)
        if stat and stat.type == "directory" then
          require("lazy").load({ plugins = { "oil.nvim" } })
        end
      end
    end,
    opts = {},
  },
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true, opts = { enable_autocmd = false } },
  { "MagicDuck/grug-far.nvim", cmd = { "GrugFar", "GrugFarWithin" } },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
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
    cmd = { "Neogit", "DiffviewOpen" },
    dependencies = {
      "nvim-lua/plenary.nvim",
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
}
