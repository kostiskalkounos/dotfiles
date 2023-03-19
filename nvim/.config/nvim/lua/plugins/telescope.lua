local status_ok, actions = pcall(require, "telescope.actions")
if not status_ok then
  return
end

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-e>"] = actions.send_to_qflist + actions.open_qflist,
        ["<c-j>"] = actions.results_scrolling_down,
        ["<c-k>"] = actions.results_scrolling_up,
        ["<esc>"] = actions.close,
      },
    },
    file_ignore_patterns = {
      "%.a",
      "%.class",
      "%.mkv",
      "%.mp4",
      "%.o",
      "%.out",
      "%.pdf",
      "%.zip",
      ".DS_Store",
      ".cache",
      ".clangd",
      ".git",
      ".venv",
      "build",
      "node_modules",
      "package-lock.json",
      "vendor",
      "yarn.lock",
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    },
  },
})

pcall(require("telescope").load_extension("fzf"))
