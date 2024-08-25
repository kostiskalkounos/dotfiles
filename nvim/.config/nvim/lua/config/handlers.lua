local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

function M.setup()
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
      border = "rounded",
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
    virtual_text = false,
  }

  vim.diagnostic.config(config)
end

function M.on_attach(client, bufnr)
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>Y", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
  vim.keymap.set("n", "<leader>g", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.keymap.set("n", "<leader>m", "<cmd>Telescope diagnostics<CR>", opts)
  vim.keymap.set("n", "<leader>o", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.keymap.set("n", "<leader>y", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  vim.keymap.set("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  vim.keymap.set("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  vim.keymap.set("n", "gD", "<cmd>Telescope lsp_definitions<CR>", opts)
  vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
end

return M
