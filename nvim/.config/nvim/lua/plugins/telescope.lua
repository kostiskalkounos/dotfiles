local status_ok, actions = pcall(require, "telescope.actions")
if not status_ok then
  return
end

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<c-a>"] = { "<home>", type = "command" },
        ["<c-e>"] = { "<end>", type = "command" },
        ["<c-j>"] = actions.cycle_history_next,
        ["<c-k>"] = actions.cycle_history_prev,
        ["<c-b>"] = actions.preview_scrolling_up,
        ["<c-f>"] = actions.preview_scrolling_down,
        ["<c-u>"] = actions.results_scrolling_up,
        ["<c-d>"] = actions.results_scrolling_down,
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
