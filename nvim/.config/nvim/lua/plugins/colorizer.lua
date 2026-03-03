return {
  "catgoose/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require("colorizer").setup({
      options = {
        parsers = {
          css = true,
          css_fn = true,
          names = {
            enable = false,
          },
        },
      },
    })
  end,
}
