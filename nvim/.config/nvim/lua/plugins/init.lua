return {
  { "almo7aya/openingh.nvim", cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" } },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "stevearc/oil.nvim", cmd = "Oil", opts = {} },
  { "MagicDuck/grug-far.nvim", cmd = { "GrugFar", "GrugFarWithin" } },
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
