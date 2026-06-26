return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  build = ":CatppuccinCompile",
  config = function()
    local o = vim.o

    local getenv = os.getenv
    local open = io.open
    local trim = vim.trim

    local theme = getenv("NVIM_THEME")
    if not theme then
      local cache_file = (getenv("HOME") or "") .. "/.cache/theme"
      local f = open(cache_file, "r")
      if f then
        theme = trim(f:read("*l") or "")
        f:close()
      end
    end
    if theme == "dark" or theme == "light" then
      o.background = theme
    end

    local catppuccin = require("catppuccin")
    local nvim_command = vim.api.nvim_command
    local stdpath = vim.fn.stdpath

    catppuccin.setup({
      compile = {
        enabled = true,
        path = stdpath("cache") .. "/catppuccin",
      },
      flavour = "auto",
      background = { light = "latte", dark = "macchiato" },
      color_overrides = {
        latte = { pink = "#d154a5" },
        macchiato = { blue = "#89b4fa", lavender = "#b4befe", sapphire = "#74c7ec" },
      },
      integrations = {
        mini = true,
      },
      custom_highlights = function(colors)
        local is_light = o.background == "light"
        return {
          ["@attribute"] = { fg = colors.sapphire },
          ["@constant"] = { fg = colors.teal },
          ["@constructor"] = { fg = colors.peach },
          ["@function.builtin"] = { fg = colors.sapphire },
          ["@keyword.operator"] = { fg = colors.mauve },
          ["@lsp.mod.constructor"] = { fg = colors.peach },
          ["@lsp.type.annotation"] = { fg = colors.sapphire },
          ["@lsp.type.annotationMember"] = { fg = colors.flamingo },
          ["@lsp.type.interface"] = { fg = colors.sapphire },
          ["@lsp.type.parameter"] = { fg = colors.text },
          ["@lsp.type.property"] = { fg = is_light and colors.pink or colors.lavender },
          ["@lsp.typemod.property.static"] = { fg = colors.teal },
          ["@module"] = { fg = colors.sapphire },
          ["@property"] = { fg = is_light and colors.pink or colors.lavender },
          ["@variable.builtin"] = { fg = colors.mauve },
          ["@variable.member"] = { fg = is_light and colors.pink or colors.lavender },
          ["@variable.parameter"] = { fg = colors.text },
          ["Constant"] = { fg = colors.teal },
          ["CurSearch"] = { bg = colors.mauve },
          ["Label"] = { fg = colors.mauve },
          ["Operator"] = { fg = colors.mauve },
          ["PreProc"] = { fg = colors.sapphire },
          ["javaTypedef"] = { fg = colors.mauve },

          NvimTreeStatusLine = { fg = colors.text, bg = colors.base },
          NvimTreeStatusLineNC = { fg = colors.surface1, bg = colors.base },
          StatusLine = { fg = colors.text, bg = colors.base },
          StatusLineNC = { fg = colors.surface1, bg = colors.base },
          StatusLineTerm = { fg = colors.text, bg = colors.base },
          StatusLineTermNC = { fg = colors.surface1, bg = colors.base },

          StlBranchIcon = { fg = colors.mauve, bg = colors.base },
        }
      end,
    })

    nvim_command("colorscheme catppuccin-nvim")
  end,
}
