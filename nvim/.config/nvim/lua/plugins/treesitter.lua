return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      { "windwp/nvim-ts-autotag", opts = {} },
    },
    config = function()
      require("nvim-treesitter").setup({
        auto_install = false,
        highlight = {
          enable = not vim.g.vscode,
          disable = function(buf)
            if vim.api.nvim_buf_line_count(buf) > 5000 then
              return true
            end
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" then
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.uv.fs_stat, name)
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end
          end,
        },
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
    end,
  },
}
