local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "󰌶" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
  local config = {
    float = {
      focusable = true,
      style = "minimal",
      border = "none",
      source = "always",
      header = "",
      prefix = "",
    },
    signs = {
      active = signs,
    },
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false, -- {
    --   severity = nil,
    --   source = "if_many",
    --   format = nil,
    -- },
  }

  vim.diagnostic.config(config)
end

M.on_attach = function(client, bufnr)
  require("plugins.lsp.formatting").setup(client, bufnr)
  require("plugins.lsp.keys").setup()
end

return M
