return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  config = function()
    local lualine_colors = {
      light = { bg = "#eff1f5", fg = "#4c4f69", inactive = "#8c8fa1" },
      dark = { bg = "#24273a", fg = "#cad3f5", inactive = "#6e738d" },
    }

    local function create_lualine_theme(colors)
      local section = { fg = colors.fg, bg = colors.bg }
      local inactive = { fg = colors.inactive, bg = colors.bg }
      return {
        normal = { a = section, b = section, c = section },
        insert = { a = section, b = section, c = section },
        visual = { a = section, b = section, c = section },
        command = { a = section, b = section, c = section },
        terminal = { a = section, b = section, c = section },
        replace = { a = section, b = section, c = section },
        inactive = { a = inactive, b = inactive, c = inactive },
      }
    end

    local bo = vim.bo
    local fn = vim.fn

    local function get_filename_display()
      local parts = {}
      local ex = fn.expand("%:~:.")
      if vim.startswith(ex, "jdt://") then
        ex = ex:match("(.-)%?")
      end
      parts[1] = ex ~= "" and ex or "[No Name]"
      if bo.modified then
        parts[#parts + 1] = " [+]"
      end
      if not bo.modifiable or bo.readonly then
        parts[#parts + 1] = " [-]"
      end

      local exp = fn.expand("%")
      if exp ~= "" and bo.buftype == "" and fn.filereadable(exp) == 0 then
        parts[#parts + 1] = " [New]"
      end
      return table.concat(parts)
    end

    local is_light = vim.o.background == "light"
    local colors = lualine_colors[is_light and "light" or "dark"]

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = create_lualine_theme(colors),
        component_separators = "",
        section_separators = "",
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { get_filename_display },
        lualine_b = { "diff" },
        lualine_c = {},
        lualine_x = {
          { "diagnostics", update_in_insert = false },
          { "branch", icon = "", padding = { left = 2 } },
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = { get_filename_display },
        lualine_b = {},
        lualine_c = {},
        lualine_x = { { "branch", padding = { left = 2 } } },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
    })
  end,
}
