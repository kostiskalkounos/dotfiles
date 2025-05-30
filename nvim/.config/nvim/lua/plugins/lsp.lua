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
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    config = function()
      local m = require("mason-nvim-dap")
      m.setup({
        ensure_installed = { "delve", "java-debug-adapter", "java-test" },
        automatic_installation = true,
        handlers = { function(config) m.default_setup(config) end },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      {
        "neovim/nvim-lspconfig",
        event = "BufReadPost",
        config = function()
          local handlers = require("config.handlers")
          local mason = require("mason")
          local mason_lspconfig = require("mason-lspconfig")
          local lspconfig = require("lspconfig")

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
            bashls = {
              filetypes = { "bash", "sh", "zsh" },
            },
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

          mason_lspconfig.setup({
            automatic_enable = false,
            ensure_installed = servers,
          })

          handlers.setup()

          for _, server_name in ipairs(servers) do
            if server_name ~= "jdtls" then
              local opts = {
                capabilities = handlers.capabilities,
                on_attach = handlers.on_attach,
                settings = servers_settings[server_name] and servers_settings[server_name].settings or nil,
              }
              lspconfig[server_name].setup(opts)
            end
          end

          local conform = require("conform")
          conform.setup({
            formatters_by_ft = {
              go = { "goimports", "gofmt" },
              javascript = { "prettier" },
              lua = { "stylua" },
              python = { "black" },
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
