return {
  "mfussenegger/nvim-jdtls",
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },
  { "stevearc/conform.nvim", event = "BufWritePre" },
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
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonUpdate" },
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          local conform = require("conform")
          local handlers = require("config.handlers")
          local mason = require("mason")
          local mason_lspconfig = require("mason-lspconfig")
          local mason_nvim_dap = require("mason-nvim-dap")

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

          for _, server_name in ipairs(servers) do
            if server_name ~= "jdtls" then
              local config = {
                capabilities = handlers.capabilities,
                on_attach = handlers.on_attach,
              }
              if servers_settings[server_name] then
                config = vim.tbl_deep_extend("force", config, servers_settings[server_name])
              end
              vim.lsp.config[server_name] = config
            end
          end

          mason.setup()

          mason_lspconfig.setup({
            automatic_enable = true,
            ensure_installed = servers,
          })

          mason_nvim_dap.setup({
            automatic_installation = true,
            ensure_installed = { "delve", "javadbg", "javatest" },
          })

          conform.setup({
            formatters_by_ft = {
              go = { "goimports", "gofmt" },
              lua = { "stylua" },
              python = { "black" },
              css = { "prettier", "prettierd", stop_after_first = true },
              html = { "prettier", "prettierd", stop_after_first = true },
              yaml = { "prettier", "prettierd", stop_after_first = true },
              jsonc = { "prettier", "prettierd", stop_after_first = true },
              javascript = { "prettier", "prettierd", stop_after_first = true },
            },
            format_on_save = function()
              if vim.g.disable_autoformat then
                return
              end
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
