local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "onedark",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      --[[ tabline = 1000, ]]
      --[[ winbar = 1000, ]]
    },
  },
  sections = {
    lualine_a = {
      {
        "branch", --[[icon = "",]]
        padding = { left = 1 },
      },
    },
    lualine_b = {},
    lualine_c = {
      "%=",
      { "filetype", icon_only = true },
      { "filename", path = 1, padding = { left = 0 } },
    },
    lualine_x = {
      {
        "diagnostics",
        symbols = { error = "E", warn = "W", info = "I", hint = "H" },
        padding = { left = 1 },
        update_in_insert = false,
      },
    },
    lualine_y = { "location" },
    lualine_z = { "progress" },
  },
  inactive_sections = {
    lualine_a = {
      {
        "branch", --[[icon = "",]]
        padding = { left = 1 },
      },
    },
    lualine_b = {},
    lualine_c = {
      "%=",
      { "filetype", icon_only = true },
      { "filename", path = 1, padding = { left = 0 } },
    },
    lualine_x = {},
    lualine_y = { "location" },
    lualine_z = { "progress" },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
