require("config.keys")
require("config.options")
require("config.autocmds")
require("config.lazy")

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("SmartEscapeSetup", { clear = true }),
  callback = function()
    if not _G.termesc then
      require("config.escape").setup({ key = "<Esc>", except = { "nvim", "fzf" } })
    end
  end,
})
