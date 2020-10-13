require("options")
require("keys")

vim.defer_fn(function()
  require("plugins")
end, 0)
