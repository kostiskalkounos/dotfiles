require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = { enable = not vim.g.vscode },
  context_commentstring = { enable = true, enable_autocmd = false },
})
