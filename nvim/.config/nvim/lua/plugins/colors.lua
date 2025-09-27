return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  dependencies = { "nvim-lualine/lualine.nvim" },
  config = function()
    local catppuccin = require("catppuccin")
    local api = vim.api
    local api_nvim_command = api.nvim_command
    local bo = vim.bo
    local fn = vim.fn
    local o = vim.o

    local function generate_highlights(palette, flavor)
      local is_light = flavor == "latte"
      return {
        ["@attribute"] = { fg = palette.sapphire },
        ["@constant"] = { fg = palette.teal },
        ["@constructor"] = { fg = palette.peach },
        ["@function.builtin"] = { fg = palette.sapphire },
        ["@keyword.operator"] = { fg = palette.mauve },
        ["@lsp.mod.constructor"] = { fg = palette.peach },
        ["@lsp.type.annotationMember"] = { fg = palette.flamingo },
        ["@lsp.type.parameter"] = { fg = palette.text },
        ["@module"] = { fg = palette.sapphire },
        ["@property"] = { fg = is_light and palette.pink or palette.lavender },
        ["@variable.builtin"] = { fg = palette.mauve },
        ["@variable.member"] = { fg = is_light and palette.pink or palette.lavender },
        ["@variable.parameter"] = { fg = palette.text },
        ["CurSearch"] = { bg = palette.mauve },
      }
    end

    local function detect_theme()
      if os.getenv("TMUX") then
        local theme = os.getenv("NVIM_THEME")
        o.background = theme
          or (fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark") and "dark" or "light")
      end
    end

    detect_theme()

    catppuccin.setup({
      flavour = "auto",
      background = { light = "latte", dark = "macchiato" },
      color_overrides = {
        latte = { pink = "#ed5bb9" },
        macchiato = { blue = "#89b4fa", lavender = "#b4befe", sapphire = "#74c7ec" },
      },
      custom_highlights = function(colors)
        local flavor = require("catppuccin").flavour
        return generate_highlights(colors, flavor)
      end,
      float = {
        enabled = false,
        border = "rounded",
        transparent = false,
        solid = false,
      },
    })

    api_nvim_command("colorscheme catppuccin")

    local lualine_colors = {
      light = { bg = "#eff1f5", fg = "#4c4f69", inactive = "#8c8fa1" },
      dark = { bg = "#24273a", fg = "#cad3f5", inactive = "#6e738d" },
    }

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

    local function create_lualine_theme(colors)
      local section = { fg = colors.fg, bg = colors.bg }
      local inactive_section = { fg = colors.inactive, bg = colors.bg }

      return {
        normal = { a = section, b = section, c = section },
        command = { a = section, b = section, c = section },
        insert = { a = section, b = section, c = section },
        visual = { a = section, b = section, c = section },
        terminal = { a = section, b = section, c = section },
        replace = { a = section, b = section, c = section },
        inactive = { a = inactive_section, b = inactive_section, c = inactive_section },
      }
    end

    local function setup_lualine()
      local is_light = o.background == "light"
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

    setup_lualine()

    api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = vim.schedule_wrap(function()
        api_nvim_command("colorscheme catppuccin")
        setup_lualine()
      end),
    })

    api.nvim_create_user_command("ToggleTheme", function()
      o.background = o.background == "light" and "dark" or "light"
    end, {})

    local lsp_token_lookup = {}
    local lsp_token_groups = {
      { type = "property", highlight = "@variable.member", priority = 105 },
      { type = "property", modifier = "static", highlight = "@constant", priority = 125 },
    }

    for _, group in ipairs(lsp_token_groups) do
      if not lsp_token_lookup[group.type] then
        lsp_token_lookup[group.type] = {}
      end
      table.insert(lsp_token_lookup[group.type], group)
    end

    api.nvim_create_autocmd("LspTokenUpdate", {
      callback = function(args)
        local token = args.data.token
        local groups = lsp_token_lookup[token.type]

        if groups then
          for _, group in ipairs(groups) do
            local should_highlight = not group.modifier or token.modifiers[group.modifier]
            if should_highlight then
              vim.lsp.semantic_tokens.highlight_token(
                token,
                args.buf,
                args.data.client_id,
                group.highlight,
                { priority = group.priority }
              )
            end
          end
        end
      end,
    })
  end,
}
