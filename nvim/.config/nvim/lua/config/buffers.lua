local M = {}

local api = vim.api
local get_current_buf = api.nvim_get_current_buf
local list_bufs = api.nvim_list_bufs
local buf_is_loaded = api.nvim_buf_is_loaded
local buf_get_name = api.nvim_buf_get_name
local get_option_value = api.nvim_get_option_value
local echo = api.nvim_echo
local cmd = vim.cmd

M.close_buffer = function()
  local buf = get_current_buf()

  if get_option_value("modified", { buf = buf }) then
    local name = buf_get_name(buf)
    echo({
      { "Unsaved changes in " .. (name ~= "" and name or "buffer" .. buf), "Title" }
    }, true, {})
    return
  end

  local normal_buf_count = 0
  for _, buf_id in ipairs(list_bufs()) do
    if buf_is_loaded(buf_id) and
        get_option_value("buftype", { buf = buf_id }) == "" then
      normal_buf_count = normal_buf_count + 1
    end
  end

  cmd(normal_buf_count <= 1 and "q" or "bd")
end

return M
