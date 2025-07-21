local M = {}

local buf = vim.lsp.buf
local diagnostic = vim.diagnostic
local float = { float = true }
local opts = { noremap = true, silent = true }
local set = vim.keymap.set

local keymap = vim.keymap
keymap.del("n", "gra")
keymap.del("n", "gri")
keymap.del("n", "grn")
keymap.del("n", "grr")
keymap.del("n", "grt")

function M.setup()
  diagnostic.config({
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true,
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

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    border = "rounded",
    max_width = math.floor(vim.o.columns * 0.7),
    max_height = math.floor(vim.o.lines * 0.7),
  })
end

local signature = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return signature({
    border = "rounded",
    max_width = math.floor(vim.o.columns * 0.4),
    max_height = math.floor(vim.o.lines * 0.5),
  })
end

function M.on_attach()
  set("n", "<leader>Y", diagnostic.setqflist, opts)
  set("n", "<leader>o", diagnostic.open_float, opts)
  set("n", "<leader>r", buf.rename, opts)
  set("n", "<leader>y", diagnostic.setloclist, opts)

  set("n", "<leader>M", "<cmd>FzfLua diagnostics_workspace<cr>", opts)
  set("n", "<leader>g", "<cmd>FzfLua lsp_code_actions<cr>", opts)
  set("n", "<leader>m", "<cmd>FzfLua diagnostics_document<cr>", opts)

  set("n", "K", buf.hover, opts)

  set("n", "[d", function()
    diagnostic.jump({ count = -1, float })
  end, opts)
  set("n", "]d", function()
    diagnostic.jump({ count = 1, float })
  end, opts)

  set("n", "[e", function()
    diagnostic.jump({ count = -1, severity = diagnostic.severity.ERROR, float })
  end, opts)
  set("n", "]e", function()
    diagnostic.jump({ count = 1, severity = diagnostic.severity.ERROR, float })
  end, opts)

  set("n", "[w", function()
    diagnostic.jump({ count = -1, severity = diagnostic.severity.WARN, float })
  end, opts)
  set("n", "]w", function()
    diagnostic.jump({ count = 1, severity = diagnostic.severity.WARN, float })
  end, opts)

  set("n", "gD", buf.definition, opts)
  set("n", "gH", buf.signature_help, opts)
  set("n", "gI", buf.implementation, opts)
  set("n", "gR", buf.references, opts)
  set("n", "gS", buf.document_symbol, opts)

  set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", opts)
  set("n", "gh", "<cmd>FzfLua lsp_typedefs<cr>", opts)
  set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opts)
  set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
  set("n", "gs", "<cmd>FzfLua lsp_document_symbols<cr>", opts)
end

return M
