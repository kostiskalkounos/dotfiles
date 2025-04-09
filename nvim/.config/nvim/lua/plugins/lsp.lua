return {
  "mfussenegger/nvim-jdtls",
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },
  { "stevearc/conform.nvim",   event = "BufWritePre" },
  { "towolf/vim-helm",         ft = "helm" },
  { "j-hui/fidget.nvim",       event = "LspAttach",  opts = {} },
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
    "jay-babu/mason-nvim-dap.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    config = function()
      local m = require "mason-nvim-dap"
      m.setup({
        ensure_installed = { "delve", "java-debug-adapter", "java-test" },
        automatic_installation = true,
        handlers = {
          function(config)
            m.default_setup(config)
          end,
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "neovim/nvim-lspconfig",
        event = "BufReadPost",
        config = function()
          local handlers = require "config.handlers"
          local mason = require "mason"
          local mason_lspconfig = require "mason-lspconfig"
          local lspconfig = require "lspconfig"

          mason.setup()

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
            lua_ls = {
              Lua = {
                diagnostics = { globals = { "hs", "jit", "require", "vim" } },
                telemetry = { enable = false },
                workspace = { checkThirdParty = false },
              },
            },
          }

          mason_lspconfig.setup({
            ensure_installed = servers,
            automatic_installation = true,
          })

          handlers.setup()

          mason_lspconfig.setup_handlers({
            function(server_name)
              if server_name ~= "jdtls" then
                lspconfig[server_name].setup({
                  capabilities = handlers.capabilities,
                  on_attach = handlers.on_attach,
                  settings = servers_settings[server_name] or {},
                })
              end
            end,
          })

          local c = require "conform"
          c.setup({
            formatters_by_ft = {
              go = { "goimports", "gofmt" },
              javascript = { "prettierd", "prettier" },
              lua = { "stylua" },
              python = { "isort", "black" },
            },
            format_on_save = function()
              if vim.g.disable_autoformat then return end
              return { timeout_ms = 500, lsp_format = "fallback", quiet = true }
            end,
          })

          vim.api.nvim_create_user_command("FormatToggle", function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            print("Autoformatting: " .. tostring(not vim.g.disable_autoformat))
          end, {})
        end,
      },
    },
  },
}
