return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  dependencies = {
    "nvim-lualine/lualine.nvim",
  },
  config = function()
    require("catppuccin").setup({
      flavour = "auto",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      color_overrides = {
        macchiato = {
          blue = "#89b4fa",
          lavender = "#b4befe",
          sapphire = "#74c7ec",
        },
      },
      highlight_overrides = {
        latte = function(latte)
          return {
            ["@attribute"] = { fg = latte.sapphire },
            ["@constant"] = { fg = latte.teal },
            ["@constructor"] = { fg = latte.peach },
            ["@function.builtin"] = { fg = latte.sapphire },
            ["@keyword.operator"] = { fg = latte.mauve },
            ["@module"] = { fg = latte.sapphire },
            ["@variable.builtin"] = { fg = latte.mauve },
            ["@variable.member"] = { fg = latte.pink },
            ["@variable.parameter"] = { fg = latte.text },

            ["@lsp.mod.constructor"] = { fg = latte.peach },
            ["@lsp.type.annotationMember"] = { fg = latte.flamingo },
            ["@lsp.type.parameter"] = { fg = latte.text },
          }
        end,
        macchiato = function(macchiato)
          return {
            ["@attribute"] = { fg = macchiato.sapphire },
            ["@constant"] = { fg = macchiato.teal },
            ["@constructor"] = { fg = macchiato.peach },
            ["@function.builtin"] = { fg = macchiato.sapphire },
            ["@keyword.operator"] = { fg = macchiato.mauve },
            ["@module"] = { fg = macchiato.sapphire },
            ["@variable.builtin"] = { fg = macchiato.mauve },
            ["@variable.member"] = { fg = macchiato.lavender },
            ["@variable.parameter"] = { fg = macchiato.text },

            ["@lsp.mod.constructor"] = { fg = macchiato.peach },
            ["@lsp.type.annotationMember"] = { fg = macchiato.flamingo },
            ["@lsp.type.interface"] = { fg = macchiato.sapphire },
            ["@lsp.type.parameter"] = { fg = macchiato.text },
          }
        end,
      },
    })
    vim.cmd.colorscheme("catppuccin")
    local M = {}
    function M.theme()
      local colors = {
        bg = "", -- "#24273a",
        fg = "", -- "#cad3f5",
        inactive = "#6e738d",
      }

      return {
        normal = {
          a = { fg = colors.fg, bg = colors.bg },
          b = { fg = colors.fg, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
        },
        command = {
          a = { fg = colors.fg, bg = colors.bg },
          b = { fg = colors.fg, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
        },
        insert = {
          a = { fg = colors.fg, bg = colors.bg },
          b = { fg = colors.fg, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
        },
        visual = {
          a = { fg = colors.fg, bg = colors.bg },
          b = { fg = colors.fg, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
        },
        terminal = {
          a = { fg = colors.fg, bg = colors.bg },
          b = { fg = colors.fg, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
        },
        replace = {
          a = { fg = colors.fg, bg = colors.bg },
          b = { fg = colors.fg, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
        },
        inactive = {
          a = { fg = colors.inactive, bg = colors.bg },
          b = { fg = colors.inactive, bg = colors.bg },
          c = { fg = colors.inactive, bg = colors.bg },
        },
      }
    end

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = M.theme(),
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          --[[ tabline = 1000, ]]
          --[[ winbar = 1000, ]]
        },
      },
      sections = {
        lualine_a = {
          function()
            local fn = vim.fn.expand("%:~:.")
            if vim.startswith(fn, "jdt://") then
              fn = string.sub(fn, 0, string.find(fn, "?") - 1)
            end
            if fn == "" then
              fn = "[No Name]"
            end
            if vim.bo.modified then
              fn = fn .. " [+]"
            end
            if vim.bo.modifiable == false or vim.bo.readonly == true then
              fn = fn .. " [-]"
            end
            local tfn = vim.fn.expand("%")
            if tfn ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(tfn) == 0 then
              fn = fn .. " [New]"
            end
            return fn
          end,
          --     { "filename", path = 1 },
        },
        lualine_b = { "diff" },
        lualine_c = {
          --[[ "%=", ]]
          --[[ { "filetype", icon_only = true, padding = { right = 0 } }, ]]
        },
        lualine_x = {
          {
            "diagnostics",
            update_in_insert = false,
          },
          {
            "branch",
            --[[ icon = "", ]]
            padding = { left = 2 },
          },
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = {
          function()
            local fn = vim.fn.expand("%:~:.")
            if vim.startswith(fn, "jdt://") then
              fn = string.sub(fn, 0, string.find(fn, "?") - 1)
            end
            if fn == "" then
              fn = "[No Name]"
            end
            if vim.bo.modified then
              fn = fn .. " [+]"
            end
            if vim.bo.modifiable == false or vim.bo.readonly == true then
              fn = fn .. " [-]"
            end
            local tfn = vim.fn.expand("%")
            if tfn ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(tfn) == 0 then
              fn = fn .. " [New]"
            end
            return fn
          end,
          --     { "filename", path = 1 },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            "branch",
            --[[ icon = "", ]]
            padding = { left = 2 },
          },
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
