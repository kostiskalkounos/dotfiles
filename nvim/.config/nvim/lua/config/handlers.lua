local M = {}

local cmp = require "cmp_nvim_lsp"

local buf = vim.lsp.buf
local diagnostic = vim.diagnostic
local float = { float = true }
local opts = { noremap = true, silent = true }
local set = vim.keymap.set


M.capabilities = cmp.default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

function M.setup()
  diagnostic.config({
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true
    },
    signs = {
      active = true,
      text = {
        [diagnostic.severity.ERROR] = "",
        [diagnostic.severity.WARN] = "",
        [diagnostic.severity.HINT] = "󰌶",
        [diagnostic.severity.INFO] = "",
      },
    },
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
  })
end

function M.on_attach()
  set("n", "<leader>Y", diagnostic.setqflist, opts)
  set("n", "<leader>g", buf.code_action, opts)
  set("n", "<leader>m", "<cmd>Telescope diagnostics<CR>", opts)
  set("n", "<leader>o", diagnostic.open_float, opts)
  set("n", "<leader>r", buf.rename, opts)
  set("n", "<leader>y", diagnostic.setloclist, opts)
  set("n", "K", buf.hover, opts)

  set("n", "[d", function() diagnostic.jump({ count = -1, float }) end, opts)
  set("n", "]d", function() diagnostic.jump({ count = 1, float }) end, opts)

  set("n", "[e", function() diagnostic.jump({ count = -1, severity = diagnostic.severity.ERROR, float }) end, opts)
  set("n", "]e", function() diagnostic.jump({ count = 1, severity = diagnostic.severity.ERROR, float }) end, opts)

  set("n", "gD", "<cmd>Telescope lsp_definitions<CR>", opts)
  set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
  set("n", "gd", buf.definition, opts)
  set("n", "gi", buf.implementation, opts)
  set("n", "gr", buf.references, opts)
end

return M
