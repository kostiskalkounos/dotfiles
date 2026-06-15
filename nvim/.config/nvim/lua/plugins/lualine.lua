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

    local nvim_buf_get_name = vim.api.nvim_buf_get_name
    local startswith = vim.startswith
    local v_b = vim.b
    local cached_cwd = vim.uv.cwd() or ""

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        cached_cwd = vim.uv.cwd() or ""
      end,
    })

    local function get_filename_display()
      local name = nvim_buf_get_name(0)
      if name == "" then
        name = "[No Name]"
      else
        if startswith(name, cached_cwd) then
          name = name:sub(#cached_cwd + 2)
        end
        if startswith(name, "jdt://") then
          name = name:match("(.-)%?") or name
        end
      end

      local bo = vim.bo
      local modified = bo.modified and " [+]" or ""
      local readonly = (not bo.modifiable or bo.readonly) and " [-]" or ""
      local is_new = (name ~= "" and bo.buftype == "" and v_b.lualine_is_new_file) and " [New]" or ""

      return name .. modified .. readonly .. is_new
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
