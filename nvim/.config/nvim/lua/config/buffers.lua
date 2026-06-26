local M = {}

local api = vim.api
local fnamemodify = vim.fn.fnamemodify
local win_findbuf = vim.fn.win_findbuf
local is_loaded = api.nvim_buf_is_loaded
local nvim_buf_delete = api.nvim_buf_delete
local nvim_buf_get_name = api.nvim_buf_get_name
local nvim_command = api.nvim_command
local nvim_echo = api.nvim_echo
local nvim_get_current_buf = api.nvim_get_current_buf
local nvim_get_option_value = api.nvim_get_option_value
local nvim_list_bufs = api.nvim_list_bufs
local nvim_set_current_buf = api.nvim_set_current_buf
local nvim_win_close = api.nvim_win_close

M.close_buffer = function()
  local buf = nvim_get_current_buf()

  local wins = win_findbuf(buf)
  if #wins > 1 then
    nvim_win_close(0, false)
    return
  end

  if nvim_get_option_value("modified", { buf = buf }) then
    local name = nvim_buf_get_name(buf)
    if name ~= "" then
      name = fnamemodify(name, ":~:.")
    end
    nvim_echo({
      { "Unsaved changes in " .. (name ~= "" and name or "Buffer " .. buf), "WarningMsg" },
    }, true, {})
    return
  end

  if not nvim_get_option_value("buflisted", { buf = buf }) or nvim_get_option_value("buftype", { buf = buf }) ~= "" then
    nvim_command("q")
    return
  end

  local normal_buf_count = 0
  for _, buf_id in ipairs(nvim_list_bufs()) do
    if nvim_get_option_value("buflisted", { buf = buf_id }) then
      local buftype = nvim_get_option_value("buftype", { buf = buf_id })
      if buftype == "" then
        normal_buf_count = normal_buf_count + 1
        if normal_buf_count > 1 then
          break
        end
      end
    end
  end

  if normal_buf_count <= 1 then
    nvim_command("q")
  else
    nvim_buf_delete(buf, { force = false })
  end
end

M.quit_all = function()
  for _, buf_id in ipairs(nvim_list_bufs()) do
    if is_loaded(buf_id)
        and nvim_get_option_value("modified", { buf = buf_id })
        and nvim_get_option_value("buftype", { buf = buf_id }) == "" then
      local current_buf = nvim_get_current_buf()
      if current_buf ~= buf_id then
        nvim_set_current_buf(buf_id)
      end

      local name = nvim_buf_get_name(buf_id)
      name = name ~= "" and fnamemodify(name, ":~:.") or ("Buffer " .. buf_id)

      nvim_echo({ { "Unsaved changes in " .. name, "WarningMsg" } }, true, {})
      return
    end
  end

  nvim_command("qa")
end

return M
