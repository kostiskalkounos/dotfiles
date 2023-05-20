require("config.keys")
require("config.options")

require("config.escape").setup({
  key = "<Esc>",
  except = { "nvim", "fzf" },
})
