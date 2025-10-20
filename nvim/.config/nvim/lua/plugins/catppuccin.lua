return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local theme = os.getenv("NVIM_THEME")
    if theme then
      vim.o.background = theme
    end

    local catppuccin = require("catppuccin")
    catppuccin.setup({
      flavour = "auto",
      background = { light = "latte", dark = "macchiato" },
      color_overrides = {
        -- latte = { pink = "#cc5092" },
        -- latte = { pink = "#c72c91" },
        latte = { pink = "#c72c91" },
        macchiato = { blue = "#89b4fa", lavender = "#b4befe", sapphire = "#74c7ec" },
      },
      custom_highlights = function(colors)
        local flavor = catppuccin.flavour
        local is_light = flavor == "latte"
        return {
          ["@attribute"] = { fg = colors.sapphire },
          ["@constant"] = { fg = colors.teal },
          ["@constructor"] = { fg = colors.peach },
          ["@function.builtin"] = { fg = colors.sapphire },
          ["@keyword.operator"] = { fg = colors.mauve },
          ["@lsp.mod.constructor"] = { fg = colors.peach },
          ["@lsp.type.annotationMember"] = { fg = colors.flamingo },
          ["@lsp.type.parameter"] = { fg = colors.text },
          ["@module"] = { fg = colors.sapphire },
          ["@property"] = { fg = is_light and colors.pink or colors.lavender },
          ["@variable.builtin"] = { fg = colors.mauve },
          ["@variable.member"] = { fg = is_light and colors.pink or colors.lavender },
          ["@variable.parameter"] = { fg = colors.text },
          ["CurSearch"] = { bg = colors.mauve },
        }
      end,
      integrations = { lualine = true },
    })

    vim.api.nvim_command("colorscheme catppuccin")
  end,
}
