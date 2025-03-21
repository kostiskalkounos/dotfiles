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
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true, buffer = bufnr }

  local mappings = {
    ["<leader>Y"] = vim.diagnostic.setqflist,
    ["<leader>g"] = vim.lsp.buf.code_action,
    ["<leader>m"] = "<cmd>Telescope diagnostics<CR>",
    ["<leader>o"] = vim.diagnostic.open_float,
    ["<leader>r"] = vim.lsp.buf.rename,
    ["<leader>y"] = vim.diagnostic.setloclist,
    ["K"] = vim.lsp.buf.hover,
    ["[d"] = vim.diagnostic.goto_prev,
    ["]d"] = vim.diagnostic.goto_next,
    ["[e"] = function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
    ["]e"] = function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
    ["gD"] = "<cmd>Telescope lsp_definitions<CR>",
    ["gI"] = "<cmd>Telescope lsp_implementations<CR>",
    ["gR"] = "<cmd>Telescope lsp_references<CR>",
    ["gd"] = vim.lsp.buf.definition,
    ["gi"] = vim.lsp.buf.implementation,
    ["gr"] = vim.lsp.buf.references,
  }

  for key, cmd in pairs(mappings) do
    keymap("n", key, cmd, opts)
  end
end

return M

