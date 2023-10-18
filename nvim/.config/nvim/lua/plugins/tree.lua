return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      filters = {
        custom = { "^.git$", "node_modules" },
      },
    })
  end,
}
