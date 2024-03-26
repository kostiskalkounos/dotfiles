return {
  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
  },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "nvim-pack/nvim-spectre", dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" } },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
    dependencies = "nvim-lua/plenary.nvim",
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
}
