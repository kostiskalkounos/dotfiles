require("config.lsp.diagnostics").setup()
require("config.lsp.kind").setup()

local function on_attach(client, bufnr)
  require("config.lsp.formatting").setup(client, bufnr)
  require("config.lsp.keys").setup()

  if client.name == "typescript" or client.name == "tsserver" then
    require("config.lsp.ts-utils").setup(client)
  end

  if vim.o.filetype == "java" then
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls").setup.add_commands()
    local opts = { noremap = true, unique = true, silent = true }
    vim.keymap.set("n", "<F9>", ":lua require'jdtls'.test_class()<CR>", opts)
    vim.keymap.set("n", "<F10>", ":lua require'jdtls'.test_nearest_method()<CR>", opts)

    local opts = { noremap = true, unique = true, silent = true }
    vim.keymap.set("n", "<F9>", ":lua require'jdtls'.test_class()<CR>", opts)
    vim.keymap.set("n", "<F10>", ":lua require'jdtls'.test_nearest_method()<CR>", opts)

    vim.cmd(
      "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
    )
    vim.cmd(
      "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
    )
    vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
    vim.cmd("command! -buffer JdtJol lua require('jdtls').jol()")
    vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
    vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")
  end
end

local servers = {
  clangd = {},
  cssls = {},
  eslint = {},
  html = {},
  jsonls = {},
  pyright = {},
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "hs", "vim" },
        },
      },
    },
  },
  tsserver = {},
  vimls = {},
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}
require("config.lsp.null-ls").setup(options)
require("config.lsp.install").setup(servers, options)
