local M = {}

function M.setup()
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  map("n", "<leader>G", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
  map("n", "<leader>R", "<cmd>:TSLspRenameFile<CR>", opts)
  map("n", "<leader>W", "<cmd>:TSLspOrganize<CR>", opts)
  map("n", "<leader>Y", "<cmd>TroubleToggle workspace_diagnostics<CR>", opts)
  map("n", "<leader>g", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  map("n", "<leader>o", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  map("n", "<leader>y", "<cmd>TroubleToggle document_diagnostics<CR>", opts)
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  map("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  map("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
  map("n", "gd", "<cmd>TroubleToggle lsp_definitions<CR>", opts)
  map("n", "gi", "<cmd>TroubleToggle lsp_implementations<CR>", opts)
  map("n", "gr", "<cmd>TroubleToggle lsp_references<CR>", opts)

  -- map("n", "<leader>Y", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
  -- map("n", "<leader>y", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  -- map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

return M
