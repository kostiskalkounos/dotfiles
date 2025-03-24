return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      { "windwp/nvim-ts-autotag", opts = {} },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
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
        highlight = { enable = not vim.g.vscode },
        indent = { enable = true },
        autopairs = { enable = true },
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

      vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "@variable.member" })
      vim.api.nvim_set_hl(0, "@lsp.typemod.property.static", { link = "@constant" })
    end,
  },
}
