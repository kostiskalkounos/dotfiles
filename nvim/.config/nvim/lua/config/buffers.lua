local M = {}

local api = vim.api
local is_loaded = api.nvim_buf_is_loaded
local fnamemodify = vim.fn.fnamemodify

M.close_buffer = function()
  local buf = api.nvim_get_current_buf()
  local bo = vim.bo

  if bo[buf].modified then
    local name = api.nvim_buf_get_name(buf)
    if name ~= "" then
      name = fnamemodify(name, ":~:.")
    end
    api.nvim_echo({
      { "Unsaved changes in " .. (name ~= "" and name or "Buffer " .. buf), "WarningMsg" },
    }, true, {})
    return
  end

  if not bo[buf].buflisted or bo[buf].buftype ~= "" then
    api.nvim_command("q")
    return
  end

  local normal_buf_count = 0
  for _, buf_id in ipairs(api.nvim_list_bufs()) do
    if bo[buf_id].buflisted then
      local buftype = bo[buf_id].buftype
      if buftype == "" then
        normal_buf_count = normal_buf_count + 1
        if normal_buf_count > 1 then
          break
        end
      end
    end
  end

  if normal_buf_count <= 1 then
    api.nvim_command("q")
  else
    api.nvim_buf_delete(buf, { force = false })
  end
end

M.quit_all = function()
  local bo = vim.bo
  for _, buf_id in ipairs(api.nvim_list_bufs()) do
    if
      is_loaded(buf_id)
      and bo[buf_id].modified
      and bo[buf_id].buftype == ""
    then
      local current_buf = api.nvim_get_current_buf()
      if current_buf ~= buf_id then
        api.nvim_set_current_buf(buf_id)
      end

      local name = api.nvim_buf_get_name(buf_id)
      name = name ~= "" and fnamemodify(name, ":~:.") or ("Buffer " .. buf_id)

      api.nvim_echo({ { "Unsaved changes in " .. name, "WarningMsg" } }, true, {})
      return
    end
  end

  api.nvim_command("qa")
end

return M
