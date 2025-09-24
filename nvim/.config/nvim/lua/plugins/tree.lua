return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
  dependencies = "nvim-tree/nvim-web-devicons",
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
}
