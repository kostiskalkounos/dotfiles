local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

function M.setup()
  vim.diagnostic.config({
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true
    },
    signs = {
      active = true,
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "󰌶",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
  })
end

function M.on_attach(client, bufnr)
  local set = vim.keymap.set
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local float = { float = true }

  set("n", "<leader>Y", vim.diagnostic.setqflist, opts)
  set("n", "<leader>g", vim.lsp.buf.code_action, opts)
  set("n", "<leader>m", "<cmd>Telescope diagnostics<CR>", opts)
  set("n", "<leader>o", vim.diagnostic.open_float, opts)
  set("n", "<leader>r", vim.lsp.buf.rename, opts)
  set("n", "<leader>y", vim.diagnostic.setloclist, opts)
  set("n", "K", vim.lsp.buf.hover, opts)

  set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float })
  end, opts)
  set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float })
  end, opts)

  set("n", "[e", function()
    vim.diagnostic.jump({
      count = -1,
      severity = vim.diagnostic.severity.ERROR,
      float
    })
  end, opts)
  set("n", "]e", function()
    vim.diagnostic.jump({
      count = 1,
      severity = vim.diagnostic.severity.ERROR,
      float
    })
  end, opts)

  set("n", "gD", "<cmd>Telescope lsp_definitions<CR>", opts)
  set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
  set("n", "gd", vim.lsp.buf.definition, opts)
  set("n", "gi", vim.lsp.buf.implementation, opts)
  set("n", "gr", vim.lsp.buf.references, opts)
end

return M
