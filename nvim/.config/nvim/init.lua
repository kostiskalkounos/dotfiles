if vim.loader then
  vim.loader.enable()
end

_G.stdpaths = {
  data = vim.fn.stdpath("data"),
  cache = vim.fn.stdpath("cache"),
}

require("config")
