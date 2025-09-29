return {
  "catgoose/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require("colorizer").setup({
      filetypes = { "*" },
      buftypes = {},
      user_commands = true,
      lazy_load = true,
      user_default_options = {
        names = false,
        names_opts = {
          lowercase = true,
          camelcase = true,
          uppercase = false,
          strip_digits = false,
        },
        names_custom = false,
        RGB = true,
        RGBA = true,
        RRGGBB = true,
        RRGGBBAA = false,
        AARRGGBB = false,
        rgb_fn = false,
        hsl_fn = false,
        css = false,
        css_fn = false,
        tailwind = false,
        tailwind_opts = {
          update_names = false,
        },
        sass = { enable = false, parsers = { "css" } },
        xterm = false,
        mode = "background",
        virtualtext = "■",
        virtualtext_inline = false,
        virtualtext_mode = "foreground",
        always_update = false,
        hooks = {
          disable_line_highlight = false,
        },
      },
    })
  end,
}
