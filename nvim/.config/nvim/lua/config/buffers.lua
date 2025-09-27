local M = {}

local api = vim.api
local buf_is_loaded = api.nvim_buf_is_loaded
local get_option_value = api.nvim_get_option_value

M.close_buffer = function()
  local buf = api.nvim_get_current_buf()

  if get_option_value("modified", { buf = buf }) then
    local name = api.nvim_buf_get_name(buf)
    api.nvim_echo({
      { "Unsaved changes in " .. (name ~= "" and name or "buffer" .. buf), "Title" },
    }, true, {})
    return
  end

  local normal_buf_count = 0
  for _, buf_id in ipairs(api.nvim_list_bufs()) do
    if buf_is_loaded(buf_id) and get_option_value("buftype", { buf = buf_id }) == "" then
      normal_buf_count = normal_buf_count + 1
    end
  end

  api.nvim_command(normal_buf_count <= 1 and "q" or "bd")
end

return M
