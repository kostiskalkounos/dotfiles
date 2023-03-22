local M = {}

M.autoformat = true

function M.format()
  if M.autoformat then
    vim.lsp.buf.format({ async = false })
  end
end

function M.setup(client, buf)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")

  local nls = require("plugins.lsp.null-ls")

  local enable = false
  if nls.has_formatter(ft) then
    enable = client.name == "null-ls"
  else
    enable = not (client.name == "null-ls")
  end

  vim.api.nvim_create_user_command("FormatToggle", function()
    M.autoformat = not M.autoformat
    print("Setting autoformatting to: " .. tostring(M.autoformat))
  end, {})

  client.server_capabilities.document_formatting = enable
  if client.server_capabilities.document_formatting and M.autoformat then
    vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("plugins.lsp.formatting").format()
      augroup END

      augroup TrimWhiteSpace
        au!
        autocmd BufWritePre * :%s/\s\+$//e
      augroup end
    ]])
  end
end

return M
