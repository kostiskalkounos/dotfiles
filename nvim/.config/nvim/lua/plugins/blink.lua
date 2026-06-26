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
      default = (function()
        local comment_nodes = { comment = true, line_comment = true, block_comment = true }
        return function()
          local sources = { "lsp", "buffer" }
          local buf = vim.api.nvim_get_current_buf()
          local has_parser = vim.treesitter.highlighter.active[buf] ~= nil

          if has_parser then
            local ok, node = pcall(vim.treesitter.get_node)
            if ok and node then
              local node_type = node:type()
              if not comment_nodes[node_type] then
                table.insert(sources, "path")
              end
              if node_type ~= "string" then
                table.insert(sources, "snippets")
              end
            end
          else
            table.insert(sources, "path")
            table.insert(sources, "snippets")
          end

          return sources
        end
      end)(),
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
