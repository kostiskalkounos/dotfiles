local M = {}
local l = vim.api.nvim_buf_is_loaded
local n = vim.api.nvim_buf_get_name
local o = vim.api.nvim_buf_get_option
M.close_buffer = function()
  local b = vim.api.nvim_get_current_buf()
  if o(b, "modified") then
    vim.api.nvim_echo({ { "Unsaved changes in " .. (n(b) ~= "" and n(b) or "buffer" .. b), "Title" } }, true, {})
    return
  end
  local c = 0
  for _, d in ipairs(vim.api.nvim_list_bufs()) do
    c = c + (l(d) and o(d, "buftype") == "" and 1 or 0)
  end
  vim.cmd(c <= 1 and "q" or "bd")
end
return M
