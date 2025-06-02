return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local f = require("fzf-lua")
    f.setup({
      { "border-fused" },
      defaults = {
        git_icons = false,
        hidden = true,
        actions = {
          ["ctrl-q"] = { fn = f.actions.file_sel_to_qf, prefix = "select-all" },
        },
      },
      fzf_colors = {
        gutter = "-1",
      },
      fzf_opts = { ["--cycle"] = true },
      keymap = {
        builtin = {
          ["<C-/>"] = "toggle-help",
          ["<C-i>"] = "toggle-preview",
          ["<C-f>"] = "preview-page-down",
          ["<C-b>"] = "preview-page-up",
        },
        fzf = {
          ["alt-s"] = "toggle",
          ["alt-a"] = "toggle-all",
          ["ctrl-i"] = "toggle-preview",
          ["ctrl-j"] = "half-page-down",
          ["ctrl-k"] = "half-page-up",
        },
      },
      winopts = {
        preview = {
          scrollbar = false,
        },
      },
    })
  end,
}
