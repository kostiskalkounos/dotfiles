return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  build = ":CatppuccinCompile",
  config = function()
    local theme = os.getenv("NVIM_THEME")
    if not theme then
      local cache_file = (os.getenv("HOME") or "") .. "/.cache/theme"
      local f = io.open(cache_file, "r")
      if f then
        theme = vim.trim(f:read("*l") or "")
        f:close()
      end
    end
    if theme == "dark" or theme == "light" then
      vim.o.background = theme
    end

    local catppuccin = require("catppuccin")
    catppuccin.setup({
      compile = {
        enabled = true,
        path = vim.fn.stdpath("cache") .. "/catppuccin",
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
        local is_light = vim.o.background == "light"
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

          MiniStatusline = { fg = colors.text, bg = colors.base },
          MiniStatuslineDiagnosticError = { fg = colors.red, bg = colors.base },
          MiniStatuslineDiagnosticHint = { fg = colors.teal, bg = colors.base },
          MiniStatuslineDiagnosticInfo = { fg = colors.blue, bg = colors.base },
          MiniStatuslineDiagnosticWarn = { fg = colors.yellow, bg = colors.base },
          MiniStatuslineInactive = { fg = colors.overlay0, bg = colors.base },

          StatusLine = { fg = colors.text, bg = colors.base },
          StatusLineNC = { fg = colors.surface1, bg = colors.base },
        }
      end,
    })

    vim.api.nvim_command("colorscheme catppuccin-nvim")
  end,
}
