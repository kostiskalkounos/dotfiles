local M = {}

function M.setup(on_attach)
  local nls = require("null-ls")

  nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
      nls.builtins.formatting.black,
      --[[ nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }), ]]
      nls.builtins.formatting.prettier,
      nls.builtins.formatting.stylua,
    },
    on_attach = on_attach,
    root_dir = require("null-ls.utils").root_pattern(vim.fn.getcwd()),
  })
end

function M.has_formatter(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return #available > 0
end

return M
