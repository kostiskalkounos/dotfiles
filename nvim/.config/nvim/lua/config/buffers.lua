local M = {}

M.close_buffer = function()
  local buf = vim.api.nvim_get_current_buf()

  local wins = vim.fn.win_findbuf(buf)
  if #wins > 1 then
    vim.api.nvim_win_close(0, false)
    return
  end

  if vim.api.nvim_get_option_value("modified", { buf = buf }) then
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" then
      name = vim.fn.fnamemodify(name, ":~:.")
    end
    vim.api.nvim_echo({
      { "Unsaved changes in " .. (name ~= "" and name or "Buffer " .. buf), "WarningMsg" },
    }, true, {})
    return
  end

  if not vim.api.nvim_get_option_value("buflisted", { buf = buf }) or vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "" then
    vim.api.nvim_command("q")
    return
  end

  local normal_buf_count = 0
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("buflisted", { buf = buf_id }) then
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf_id })
      if buftype == "" then
        normal_buf_count = normal_buf_count + 1
        if normal_buf_count > 1 then
          break
        end
      end
    end
  end

  if normal_buf_count <= 1 then
    vim.api.nvim_command("q")
  else
    vim.api.nvim_buf_delete(buf, { force = false })
  end
end

M.quit_all = function()
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(buf_id)
      and vim.api.nvim_get_option_value("modified", { buf = buf_id })
      and vim.api.nvim_get_option_value("buftype", { buf = buf_id }) == ""
    then
      local current_buf = vim.api.nvim_get_current_buf()
      if current_buf ~= buf_id then
        vim.api.nvim_set_current_buf(buf_id)
      end

      local name = vim.api.nvim_buf_get_name(buf_id)
      name = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or ("Buffer " .. buf_id)

      vim.api.nvim_echo({ { "Unsaved changes in " .. name, "WarningMsg" } }, true, {})
      return
    end
  end

  vim.api.nvim_command("qa")
end

return M
