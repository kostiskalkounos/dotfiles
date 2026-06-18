return {
  "nvim-mini/mini.files",
  event = "VeryLazy",
  version = "*",
  config = function()
    require("mini.files").setup()
  end,
}
