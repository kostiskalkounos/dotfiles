if vim.loader then
  vim.loader.enable()
end

require("vim._core.ui2").enable({})

_G.stdpaths = {
  data = vim.fn.stdpath("data"),
  cache = vim.fn.stdpath("cache"),
}

require("config")
