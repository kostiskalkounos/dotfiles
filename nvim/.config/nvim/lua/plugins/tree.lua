local status_ok, tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

tree.setup({
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  filters = {
    custom = { ".git", "node_modules" },
  },
})
