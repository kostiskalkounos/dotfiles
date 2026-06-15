return {
  "catgoose/nvim-colorizer.lua",
  ft = { "css", "html", "javascript", "typescript", "lua", "yaml", "json" },
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
