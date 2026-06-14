return {
  { "mfussenegger/nvim-jdtls", ft = "java" },
  { "lewis6991/gitsigns.nvim", event = { "BufReadPost", "BufNewFile" }, opts = {} },
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    event = "BufWritePre",
    config = function()
      local prettier = { "prettier", "prettierd", stop_after_first = true }
      require("conform").setup({
        formatters_by_ft = {
          go = { "goimports", "gofmt" },
          lua = { "stylua" },
          python = { "black" },
          css = prettier,
          html = prettier,
          yaml = prettier,
          jsonc = prettier,
          javascript = prettier,
        },
        format_on_save = function()
          if vim.g.disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback", quiet = true }
        end,
      })
    end,
    init = function()
      local g = vim.g
      vim.api.nvim_create_user_command("FormatToggle", function()
        g.disable_autoformat = not g.disable_autoformat
        vim.notify("Autoformatting: " .. tostring(not g.disable_autoformat))
      end, {})
    end,
  },
  { "towolf/vim-helm", ft = "helm" },
  { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local handlers = require("config.handlers")
      handlers.setup()

      local servers = {
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "eslint",
        "gopls",
        "helm_ls",
        "html",
        "jdtls",
        "jsonls",
        "lemminx",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "taplo",
        "terraformls",
        "ts_ls",
        "vimls",
        "yamlls",
      }

      local servers_settings = {
        bashls = { filetypes = { "bash", "sh", "zsh" } },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "hs", "jit", "require", "vim" } },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
            },
          },
        },
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_enable = false,
        ensure_installed = servers,
      })

      local lsp = vim.lsp
      for _, server_name in ipairs(servers) do
        if server_name ~= "jdtls" then
          local config = {
            on_attach = handlers.on_attach,
          }
          if servers_settings[server_name] then
            config = vim.tbl_deep_extend("force", config, servers_settings[server_name])
          end
          lsp.config[server_name] = config
          lsp.enable(server_name)
        end
      end

      vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "@variable.member", default = true })
      vim.api.nvim_set_hl(0, "@lsp.typemod.property.static", { link = "@constant", default = true })
    end,
  },
}
