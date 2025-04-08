return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local actions = require "telescope.actions"

    require "telescope".setup({
      defaults = {
        mappings = {
          i = {
            ["<c-a>"] = { "<home>", type = "command" },
            ["<c-e>"] = { "<end>", type = "command" },
            ["<c-j>"] = actions.cycle_history_next,
            ["<c-k>"] = actions.cycle_history_prev,
            ["<c-n>"] = actions.results_scrolling_down,
            ["<c-p>"] = actions.results_scrolling_up,
            ["<esc>"] = actions.close,
            ["<m-h>"] = actions.results_scrolling_left,
            ["<m-j>"] = actions.preview_scrolling_left,
            ["<m-k>"] = actions.preview_scrolling_right,
            ["<m-l>"] = actions.results_scrolling_right,
          },
        },
        file_ignore_patterns = {
          ".DS_Store",
          ".cache",
          ".clangd",
          ".git",
          ".venv",
          "node_modules",
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

    require "telescope".load_extension("fzf")
  end,
}
