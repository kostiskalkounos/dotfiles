require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

local capabilities = require("plugins.lsp.handlers").capabilities
local on_attach = require("plugins.lsp.handlers").on_attach

local servers = {
  bashls = {},
  clangd = {},
  cssls = {},
  dockerls = {},
  eslint = {},
  gopls = {},
  helm_ls = {},
  html = {},
  jsonls = {},
  lemminx = {},
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "hs", "vim", "jit" },
      },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
  pyright = {},
  taplo = {},
  terraformls = {},
  tsserver = {},
  vimls = {},
  yamlls = {},
}

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    })
  end,
})

require("plugins.lsp.null-ls").setup(on_attach)
