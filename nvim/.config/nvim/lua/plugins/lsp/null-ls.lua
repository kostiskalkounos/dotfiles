local M = {}

function M.setup(options)
  local status_ok, nls = pcall(require, "null-ls")
  if not status_ok then
    return
  end

  nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
      nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }),
      nls.builtins.formatting.google_java_format,
      nls.builtins.formatting.prettierd,
      nls.builtins.formatting.stylua,
      -- nls.builtins.formatting.eslint_d,
    },
    on_attach = options.on_attach,
    root_dir = require("null-ls.utils").root_pattern(vim.fn.getcwd()),
  })
end

function M.has_formatter(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return #available > 0
end

return M
