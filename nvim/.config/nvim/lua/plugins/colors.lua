return {
  --[[ "kostiskalkounos/onedark", ]]
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  dependencies = {
    "nvim-lualine/lualine.nvim",
  },
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
    })
    vim.cmd.colorscheme("catppuccin")
    local M = {}
    M.theme = function()
      local colors = {
        bg = "#24273a",
        fg = "#cad3f5",
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
        -- theme = "onedark",
        -- theme = "catppuccin",
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
