local M = {}

local function count_bufs_by_type(loaded_only)
  loaded_only = loaded_only ~= false
  local count = { acwrite = 0, help = 0, nofile = 0, normal = 0, nowrite = 0, prompt = 0, quickfix = 0, terminal = 0 }

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not loaded_only or vim.api.nvim_buf_is_loaded(buf) then
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      buftype = buftype == "" and "normal" or buftype
      count[buftype] = count[buftype] + 1
    end
  end

  return count
end

function M.close_buffer()
  local current_buf = vim.api.nvim_get_current_buf()

  if vim.api.nvim_buf_get_option(current_buf, "modified") then
    local filename = vim.api.nvim_buf_get_name(current_buf)
    filename = filename ~= "" and filename or "buffer" .. tostring(current_buf)
    vim.api.nvim_echo({ { "Unsaved changes in " .. filename, "ErrorMsg" } }, true, {})
    return
  end

  local normal_bufs = count_bufs_by_type().normal
  if normal_bufs <= 1 then
    vim.cmd("q")
  else
    vim.cmd("bd")
  end
end

return M
