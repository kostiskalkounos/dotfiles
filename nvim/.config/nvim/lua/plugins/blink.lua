return {
  "saghen/blink.cmp",
  event = "VeryLazy",
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  opts = {
    keymap = {
      ["<C-Space>"] = { "show" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<cr>"] = { "accept", "fallback" },
    },
    completion = {
      list = {
        selection = { preselect = true, auto_insert = false },
        max_items = 10,
      },
      menu = {
        auto_show = true,
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
    },
    cmdline = { enabled = false },
    sources = {
      default = (function()
        local comment_nodes = { comment = true, line_comment = true, block_comment = true }
        local nvim_get_current_buf = vim.api.nvim_get_current_buf
        local ts_highlighter_active = vim.treesitter.highlighter.active
        local ts_get_node = vim.treesitter.get_node
        local table_insert = table.insert
        return function()
          local sources = { "lsp", "lazydev", "buffer" }
          local buf = nvim_get_current_buf()
          local has_parser = ts_highlighter_active[buf] ~= nil

          if has_parser then
            local ok, node = pcall(ts_get_node)
            if ok and node then
              local node_type = node:type()
              if not comment_nodes[node_type] then
                table_insert(sources, "path")
              end
              if node_type ~= "string" then
                table_insert(sources, "snippets")
              end
            end
          else
            table_insert(sources, "path")
            table_insert(sources, "snippets")
          end

          return sources
        end
      end)(),
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
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
    local lsp_config = vim.lsp.config
    blink.setup(opts)
    lsp_config("*", { capabilities = blink.get_lsp_capabilities(nil, true) })
  end,
}
