return {
  { "j-hui/fidget.nvim", event = "VeryLazy", opts = {} },
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
  { "mfussenegger/nvim-jdtls", event = "VeryLazy" },
  { "towolf/vim-helm", event = "VeryLazy" },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
      local prettier = { "prettier" }
      require("conform").setup({
        formatters_by_ft = {
          go = { "goimports", "gofumpt" },
          lua = { "stylua" },
          python = { "black" },
          css = prettier,
          html = prettier,
          yaml = prettier,
          json = prettier,
          jsonc = prettier,
          javascript = prettier,
          typescript = prettier,
          typescriptreact = prettier,
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
  {
    "folke/lazydev.nvim",
    event = "VeryLazy",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
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
        "stylua",
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
      local mason_registry = require("mason-registry")
      local tools = {
        "black",
        "gofumpt",
        "goimports",
        "isort",
        "prettier",
        "stylua",
      }

      mason_registry.refresh(function()
        for _, tool in ipairs(tools) do
          local pkg = mason_registry.get_package(tool)
          if not pkg:is_installed() then
            pkg:install()
          end
        end
      end)

      local lsp = vim.lsp
      lsp.config("*", {
        on_attach = handlers.on_attach,
      })

      for _, server_name in ipairs(servers) do
        if server_name ~= "jdtls" then
          if servers_settings[server_name] then
            lsp.config[server_name] = servers_settings[server_name]
          end
          lsp.enable(server_name)
        end
      end
    end,
  },
}
