require("config.keys")
require("config.options")
require("config.autocmds")
require("config.lazy")

local c = require("config.escape")
c.setup({ key = "<Esc>", except = { "nvim", "fzf" } })
