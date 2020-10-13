require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  filters = {
    custom = { ".git", "node_modules" },
  },
})
