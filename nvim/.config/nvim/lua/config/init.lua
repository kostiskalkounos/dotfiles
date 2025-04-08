require "config.keys"
require "config.options"
require "config.autocmds"
require "config.lazy"

require "config.escape".setup({
  key = "<Esc>",
  except = { "nvim", "fzf" },
})
