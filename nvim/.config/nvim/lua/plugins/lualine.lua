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
    lualine_b = {},
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
