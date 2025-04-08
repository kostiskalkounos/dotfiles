return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  dependencies = { "nvim-lualine/lualine.nvim" },
  config = function()
    local catppuccin = require "catppuccin"

    local highlight_cache = {}

    local function generate_highlights(palette, is_light)
      local key = tostring(palette) .. tostring(is_light)
      if highlight_cache[key] then
        return highlight_cache[key]
      end

      local highlights = {
        ["@attribute"] = { fg = palette.sapphire },
        ["@constant"] = { fg = palette.teal },
        ["@constructor"] = { fg = palette.peach },
        ["@function.builtin"] = { fg = palette.sapphire },
        ["@keyword.operator"] = { fg = palette.mauve },
        ["@lsp.mod.constructor"] = { fg = palette.peach },
        ["@lsp.type.annotationMember"] = { fg = palette.flamingo },
        ["@lsp.type.parameter"] = { fg = palette.text },
        ["@module"] = { fg = palette.sapphire },
        ["@variable.builtin"] = { fg = palette.mauve },
        ["@variable.member"] = { fg = is_light and palette.pink or palette.lavender },
        ["@variable.parameter"] = { fg = palette.text },
        ["CurSearch"] = { bg = palette.mauve },
      }
      highlight_cache[key] = highlights
      return highlights
    end

    catppuccin.setup({
      flavour = "auto",
      background = { light = "latte", dark = "macchiato" },
      color_overrides = {
        macchiato = { blue = "#89b4fa", lavender = "#b4befe", sapphire = "#74c7ec" },
      },
      highlight_overrides = {
        latte = function(latte) return generate_highlights(latte, true) end,
        macchiato = function(macchiato) return generate_highlights(macchiato, false) end,
      },
    })

    vim.cmd.colorscheme("catppuccin")

    if os.getenv("TMUX") then
      local theme = os.getenv("NVIM_THEME")
      vim.o.background = theme or (
        vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark") and "dark" or "light"
      )
    end

    local lualine_themes = {
      light = {
        bg = "#eff1f5",
        fg = "#4c4f69",
        inactive = "#8c8fa1",
      },
      dark = {
        bg = "#24273a",
        fg = "#cad3f5",
        inactive = "#6e738d",
      },
    }

    local function get_mode_section(colors)
      return {
        a = { fg = colors.fg, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      }
    end

    local function filename_component()
      return function()
        local fn = vim.fn.expand("%:~:.")
        if vim.startswith(fn, "jdt://") then
          fn = fn:match("(.-)%?")
        end
        if fn == "" then fn = "[No Name]" end
        if vim.bo.modified then fn = fn .. " [+]" end
        if not vim.bo.modifiable or vim.bo.readonly then fn = fn .. " [-]" end
        if vim.fn.expand("%") ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(vim.fn.expand("%")) == 0 then
          fn = fn .. " [New]"
        end
        return fn
      end
    end

    local function setup_lualine()
      local is_light = vim.o.background == "light"
      local colors = lualine_themes[is_light and "light" or "dark"]
      local mode = get_mode_section(colors)

      require "lualine".setup({
        options = {
          icons_enabled = true,
          theme = {
            normal = mode,
            command = mode,
            insert = mode,
            visual = mode,
            terminal = mode,
            replace = mode,
            inactive = { a = { fg = colors.inactive, bg = colors.bg }, b = { fg = colors.inactive, bg = colors.bg }, c = { fg = colors.inactive, bg = colors.bg } },
          },
          component_separators = "",
          section_separators = "",
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { filename_component() },
          lualine_b = { "diff" },
          lualine_c = {},
          lualine_x = { { "diagnostics", update_in_insert = false }, { "branch", padding = { left = 2 } } },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
        inactive_sections = {
          lualine_a = { filename_component() },
          lualine_b = {},
          lualine_c = {},
          lualine_x = { { "branch", padding = { left = 2 } } },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
      })
    end

    setup_lualine()
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = function() vim.schedule(setup_lualine) end,
    })

    vim.api.nvim_create_user_command("ToggleTheme", function()
      vim.o.background = vim.o.background == "light" and "dark" or "light"
    end, {})
  end,
}
