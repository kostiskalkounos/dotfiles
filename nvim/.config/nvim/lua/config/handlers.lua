local M = {}

local api = vim.api
local diag = vim.diagnostic
local lsp_buf = vim.lsp.buf
local o = vim.o

local floor = math.floor
local nvim_create_augroup = api.nvim_create_augroup
local nvim_create_autocmd = api.nvim_create_autocmd
local set = vim.keymap.set

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
  underline = true,
  update_in_insert = false,
  virtual_text = false,
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

  set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", opt)
  set("n", "gh", "<cmd>FzfLua lsp_typedefs<cr>", opt)
  set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opt)
  set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opt)
  set("n", "gs", "<cmd>FzfLua lsp_document_symbols<cr>", opt)
  set("n", "<M-cr>", "<cmd>FzfLua lsp_code_actions<cr>", opt)
  set("n", "<leader>g", "<cmd>FzfLua lsp_code_actions<cr>", opt)
  set("n", "<leader>M", "<cmd>FzfLua diagnostics_workspace<cr>", opt)
  set("n", "<leader>m", "<cmd>FzfLua diagnostics_document<cr>", opt)
end

function M.setup()
  diag.config(diag_cfg)
  local default_maps = { "gra", "gri", "grn", "grr", "grt", "grx" }
  local del = vim.keymap.del
  for _, map_str in ipairs(default_maps) do
    pcall(del, { "n", "x" }, map_str)
  end

  nvim_create_autocmd("LspAttach", {
    group = nvim_create_augroup("FastLspAttach", { clear = true }),
    callback = on_lsp_attach,
  })
end

return M
