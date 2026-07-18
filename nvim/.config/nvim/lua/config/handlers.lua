local M = {}

local api = vim.api
local diag = vim.diagnostic
local lsp_buf = vim.lsp.buf
local o = vim.o
local keymap = vim.keymap

local floor = math.floor
local nvim_create_augroup = api.nvim_create_augroup
local nvim_create_autocmd = api.nvim_create_autocmd
local set = keymap.set

local diag_cfg = {
  float = { focusable = true, style = "minimal", border = "rounded", source = true },
  signs = {
    text = {
      [diag.severity.ERROR] = "",
      [diag.severity.WARN] = "",
      [diag.severity.INFO] = "",
      [diag.severity.HINT] = "󰌶",
    },
  },
  severity_sort = true,
}

local function get_dims(width_ratio, height_ratio)
  return {
    border = "rounded",
    max_width = floor(o.columns * width_ratio),
    max_height = floor(o.lines * height_ratio),
  }
end

local function hover()
  lsp_buf.hover(get_dims(0.7, 0.7))
end

local function signature_help()
  lsp_buf.signature_help(get_dims(0.4, 0.5))
end

local SEV_ERR = diag.severity.ERROR
local SEV_WARN = diag.severity.WARN

local function on_lsp_attach(ev)
  local buf = ev.buf
  local opt = { buffer = buf, silent = true }

  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if client and client:supports_method("textDocument/documentColor") then
    vim.lsp.document_color.enable(true, { bufnr = buf })
  end

  set("n", "K", hover, opt)
  set("n", "gH", signature_help, opt)
  set("n", "<leader>r", lsp_buf.rename, opt)

  set("n", "[d", function()
    diag.jump({ count = -1, float = true })
  end, opt)

  set("n", "]d", function()
    diag.jump({ count = 1, float = true })
  end, opt)

  set("n", "[e", function()
    diag.jump({ count = -1, severity = SEV_ERR, float = true })
  end, opt)

  set("n", "]e", function()
    diag.jump({ count = 1, severity = SEV_ERR, float = true })
  end, opt)

  set("n", "[w", function()
    diag.jump({ count = -1, severity = SEV_WARN, float = true })
  end, opt)

  set("n", "]w", function()
    diag.jump({ count = 1, severity = SEV_WARN, float = true })
  end, opt)

  set("n", "<leader>Y", diag.setqflist, opt)
  set("n", "<leader>y", diag.setloclist, opt)
  set("n", "<leader>o", diag.open_float, opt)

  set("n", "gS", function() require("fzf-lua").lsp_document_symbols() end, opt)
  set("n", "gd", function() require("fzf-lua").lsp_definitions() end, opt)
  set("n", "gh", function() require("fzf-lua").lsp_typedefs() end, opt)
  set("n", "gi", function() require("fzf-lua").lsp_implementations() end, opt)
  set("n", "gr", function() require("fzf-lua").lsp_references() end, opt)
  set("n", "gs", function() require("fzf-lua").lsp_live_workspace_symbols() end, opt)
  set("n", "<M-cr>", function() require("fzf-lua").lsp_code_actions() end, opt)
  set("n", "<leader>M", function() require("fzf-lua").diagnostics_workspace() end, opt)
  set("n", "<leader>g", function() require("fzf-lua").lsp_code_actions() end, opt)
  set("n", "<leader>m", function() require("fzf-lua").diagnostics_document() end, opt)
end

function M.setup()
  diag.config(diag_cfg)
  local default_maps = { "gra", "gri", "grn", "grr", "grt", "grx" }
  for _, map_str in ipairs(default_maps) do
    pcall(keymap.del, { "n", "x" }, map_str)
  end

  nvim_create_autocmd("LspAttach", {
    group = nvim_create_augroup("FastLspAttach", { clear = true }),
    callback = on_lsp_attach,
  })
end

return M
