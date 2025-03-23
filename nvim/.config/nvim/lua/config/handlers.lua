local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

function M.setup()
  vim.fn.sign_define({
    { name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError", numhl = "" },
    { name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticSignWarn", numhl = "" },
    { name = "DiagnosticSignHint", text = "󰌶", texthl = "DiagnosticSignHint", numhl = "" },
    { name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticSignInfo", numhl = "" },
  })

  vim.diagnostic.config({
    float = { focusable = true, style = "minimal", border = "rounded", source = "always" },
    signs = { active = true },
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
  })
end

function M.on_attach(client, bufnr)
  local set = vim.keymap.set
  local opts = { noremap = true, silent = true, buffer = bufnr }

  set("n", "<leader>Y", vim.diagnostic.setqflist, opts)
  set("n", "<leader>g", vim.lsp.buf.code_action, opts)
  set("n", "<leader>m", "<cmd>Telescope diagnostics<CR>", opts)
  set("n", "<leader>o", vim.diagnostic.open_float, opts)
  set("n", "<leader>r", vim.lsp.buf.rename, opts)
  set("n", "<leader>y", vim.diagnostic.setloclist, opts)
  set("n", "K", vim.lsp.buf.hover, opts)
  set("n", "[d", vim.diagnostic.goto_prev, opts)
  set("n", "]d", vim.diagnostic.goto_next, opts)
  set("n", "[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, opts)
  set("n", "]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, opts)
  set("n", "gD", "<cmd>Telescope lsp_definitions<CR>", opts)
  set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
  set("n", "gd", vim.lsp.buf.definition, opts)
  set("n", "gi", vim.lsp.buf.implementation, opts)
  set("n", "gr", vim.lsp.buf.references, opts)
end

return M
