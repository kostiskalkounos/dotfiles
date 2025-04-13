return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      { "windwp/nvim-ts-autotag",     opts = {} },
    },
    config = function()
      local ts_config = require "nvim-treesitter.configs"
      ts_config.setup({
        auto_install = false,
        autopairs = { enable = true },
        highlight = { enable = not vim.g.vscode },
        ignore_install = {},
        indent = { enable = true },
        modules = {},
        sync_install = false,
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitcommit",
          "go",
          "groovy",
          "html",
          "java",
          "javascript",
          "json",
          "lua",
          "nix",
          "python",
          "rust",
          "terraform",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "xml",
          "yaml",
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]]"] = "@class.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]["] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[["] = "@class.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[]"] = "@class.outer" },
          },
          swap = {
            enable = true,
            swap_next = { ["[p"] = "@parameter.inner" },
            swap_previous = { ["]p"] = "@parameter.inner" },
          },
        },
      })

      local set = vim.api.nvim_set_hl
      set(0, "@lsp.type.property", { link = "@variable.member" })
      set(0, "@lsp.typemod.property.static", { link = "@constant" })
    end,
  },
}
