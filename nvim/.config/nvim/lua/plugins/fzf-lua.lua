return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = "nvim-mini/mini.icons",
  config = function()
    local f = require("fzf-lua")
    local cache = _G.stdpaths.cache

    if _G.update_fzf_opts then
      _G.update_fzf_opts()
    end

    f.setup({
      fzf_opts = {
        ["--cycle"] = true,
      },
      defaults = {
        git_icons = false,
        hidden = true,
      },
      actions = {
        files = {
          true,
          ["ctrl-q"] = { fn = f.actions.file_sel_to_qf, prefix = "select-all" },
        },
      },
      files = {
        fzf_opts = {
          ["--history"] = cache .. "/fzf-files-history",
        },
      },
      grep = {
        fzf_opts = {
          ["--history"] = cache .. "/fzf-grep-history",
        },
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

    f.register_ui_select()
  end,
}
