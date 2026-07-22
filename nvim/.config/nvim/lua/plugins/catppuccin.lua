return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  build = ":CatppuccinCompile",
  config = function()
    local catppuccin = require("catppuccin")
    catppuccin.setup({
      auto_integrations = false,
      integrations = {
        blink_cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        fidget = true,
        fzf = true,
        gitsigns = true,
        grug_far = true,
        mason = true,
        mini = true,
        native_lsp = { enabled = true },
        neogit = true,
        nvimtree = true,
        render_markdown = true,
        treesitter = true,
      },
      compile = {
        enabled = true,
        path = _G.stdpaths.cache .. "/catppuccin",
      },
      flavour = "auto",
      background = { light = "latte", dark = "macchiato" },
      color_overrides = {
        latte = { pink = "#d154a5" },
        macchiato = { blue = "#89b4fa", lavender = "#b4befe", sapphire = "#74c7ec" },
      },
      highlight_overrides = {
        all = function(colors)
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
            ["@lsp.typemod.property.static"] = { fg = colors.teal },
            ["@module"] = { fg = colors.sapphire },
            ["@variable.builtin"] = { fg = colors.mauve },
            ["@variable.parameter"] = { fg = colors.text },
            ["Constant"] = { fg = colors.teal },
            ["CurSearch"] = { bg = colors.mauve },
            ["Label"] = { fg = colors.mauve },
            ["Operator"] = { fg = colors.mauve },
            ["PreProc"] = { fg = colors.sapphire },
            ["javaTypedef"] = { fg = colors.mauve },

            BlinkCmpMenuSelection = { bg = colors.surface0 },
            NvimTreeStatusLine = { fg = colors.text, bg = colors.base },
            NvimTreeStatusLineNC = { fg = colors.surface1, bg = colors.base },
            StatusLine = { fg = colors.text, bg = colors.base },
            StatusLineNC = { fg = colors.surface1, bg = colors.base },
            StatusLineTerm = { fg = colors.text, bg = colors.base },
            StatusLineTermNC = { fg = colors.surface1, bg = colors.base },
            StlBranchIcon = { fg = colors.mauve, bg = colors.base },
          }
        end,
        latte = function(colors)
          return {
            ["@lsp.type.property"] = { fg = colors.pink },
            ["@property"] = { fg = colors.pink },
            ["@variable.member"] = { fg = colors.pink },
          }
        end,
        macchiato = function(colors)
          return {
            ["@lsp.type.property"] = { fg = colors.lavender },
            ["@property"] = { fg = colors.lavender },
            ["@variable.member"] = { fg = colors.lavender },
          }
        end,
      },
    })

    vim.api.nvim_command("colorscheme catppuccin")
  end,
}
