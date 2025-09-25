return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  event = "InsertEnter",
  opts = {
    keymap = {
      ["<cr>"] = { "accept", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "show", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    completion = {
      list = {
        selection = { preselect = true, auto_insert = false },
        max_items = 10,
      },
      menu = {
        auto_show = true,
        border = "rounded",
        winhighlight = "Normal:BlinkCmpLabel",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDocBorder",
        },
      },
    },
    cmdline = { enabled = false },
    sources = {
      default = function()
        local sources = { "lsp", "buffer" }
        local ok, node = pcall(vim.treesitter.get_node)

        if ok and node then
          if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            table.insert(sources, "path")
          end
          if node:type() ~= "string" then
            table.insert(sources, "snippets")
          end
        end

        return sources
      end,
    },
    appearance = {
      kind_icons = {
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Operator = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      },
    },
  },
  config = function(_, opts)
    local blink = require("blink.cmp")
    blink.setup(opts)
    vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities(nil, true) })
  end,
}
