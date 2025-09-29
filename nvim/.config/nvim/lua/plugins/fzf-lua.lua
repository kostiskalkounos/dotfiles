return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local f = require("fzf-lua")
    vim.api.nvim_command("FzfLua register_ui_select")

    f.setup({
      fzf_opts = {
        ["--cycle"] = true,
      },
      defaults = {
        git_icons = false,
        hidden = true,
        actions = {
          ["ctrl-q"] = { fn = f.actions.file_sel_to_qf, prefix = "select-all" },
        },
      },
      files = {
        fzf_opts = {
          ["--history"] = "/tmp/fzf-lua-files-history",
        },
      },
      grep = {
        fzf_opts = {
          ["--history"] = "/tmp/fzf-lua-grep-history",
        },
      },
      fzf_colors = {
        gutter = "-1",
      },
      keymap = {
        builtin = {
          ["<C-/>"] = "toggle-help",
          ["<C-i>"] = "toggle-preview",
          ["<C-b>"] = "preview-page-up",
          ["<C-f>"] = "preview-page-down",
          ["<S-Tab>"] = "toggle-preview-wrap",
        },
        fzf = {
          ["alt-s"] = "toggle",
          ["alt-a"] = "toggle-all",
          ["ctrl-k"] = "half-page-up",
          ["ctrl-j"] = "half-page-down",
        },
      },
      winopts = {
        backdrop = 100,
        border = "rounded",
        preview = {
          border = "rounded",
          layout = "vertical",
          scrollbar = false,
          vertical = "down:55%",
        },
      },
    })
  end,
}
