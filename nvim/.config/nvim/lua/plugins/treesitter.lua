local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

treesitter.setup({
  ensure_installed = "all",
  highlight = { enable = not vim.g.vscode },
  context_commentstring = { enable = true, enable_autocmd = false },
  autopairs = {
    enable = true,
  },
})

-- -- Disable semantic highlighting
-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--   vim.api.nvim_set_hl(0, group, {})
-- end
