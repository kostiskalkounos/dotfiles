return {
  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
    cmd = "Spectre",
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    opts = {},
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = "nvim-lua/plenary.nvim",
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
