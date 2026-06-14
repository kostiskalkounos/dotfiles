return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  priority = 999,
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

    local function get_filename_display()
      local parts = {}
      local bufname = vim.api.nvim_buf_get_name(0)
      local ex = bufname

      if ex == "" then
        parts[1] = "[No Name]"
      else
        local cwd = vim.uv.cwd() or ""
        if vim.startswith(ex, cwd) then
          ex = ex:sub(#cwd + 2)
        end
        if vim.startswith(ex, "jdt://") then
          ex = ex:match("(.-)%?") or ex
        end
        parts[1] = ex
      end

      if bo.modified then
        parts[#parts + 1] = " [+]"
      end
      if not bo.modifiable or bo.readonly then
        parts[#parts + 1] = " [-]"
      end

      if bufname ~= "" and bo.buftype == "" then
        if vim.b.lualine_is_new_file == nil then
          vim.b.lualine_is_new_file = not vim.uv.fs_stat(bufname)
        end
        if vim.b.lualine_is_new_file then
          parts[#parts + 1] = " [New]"
        end
      end
      return table.concat(parts)
    end

    local function reload_lualine()
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
    end

    reload_lualine()

    local lualine_group = vim.api.nvim_create_augroup("LualineThemeReload", { clear = true })
    vim.api.nvim_create_autocmd("OptionSet", {
      group = lualine_group,
      pattern = "background",
      callback = reload_lualine,
    })
  end,
}
