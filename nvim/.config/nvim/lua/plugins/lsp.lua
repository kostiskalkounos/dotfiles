return {
  { "j-hui/fidget.nvim", event = "VeryLazy", opts = {} },
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
  { "mfussenegger/nvim-jdtls", event = "VeryLazy" },
  { "towolf/vim-helm", event = "VeryLazy" },
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
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
      local prettier = { "prettier" }
      local g = vim.g
      require("conform").setup({
        formatters_by_ft = {
          go = { "goimports", "gofumpt" },
          lua = { "stylua" },
          python = { "isort", "black" },
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
          if g.disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback", quiet = true }
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("config.handlers").setup()

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

      local tools = {
        "black",
        "gofumpt",
        "goimports",
        "isort",
        "prettier",
        "stylua",
      }
      local flag_file = _G.stdpaths.cache .. "/mason_tools_" .. table.concat(tools, "_")
      local uv = vim.uv or vim.loop
      if not uv.fs_stat(flag_file) then
        local mason_registry = require("mason-registry")

        local missing_tools = {}
        for _, tool in ipairs(tools) do
          if not mason_registry.is_installed(tool) then
            table.insert(missing_tools, tool)
          end
        end

        if #missing_tools > 0 then
          mason_registry.refresh(function()
            for _, tool in ipairs(missing_tools) do
              local pkg = mason_registry.get_package(tool)
              if not pkg:is_installed() then
                pkg:install()
              end
            end
            local f = io.open(flag_file, "w")
            if f then
              f:write("ok")
              f:close()
            end
          end)
        else
          local f = io.open(flag_file, "w")
          if f then
            f:write("ok")
            f:close()
          end
        end
      end

      local lsp = vim.lsp

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
