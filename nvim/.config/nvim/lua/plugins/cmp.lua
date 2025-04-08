return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    "windwp/nvim-autopairs",
  },
  config = function()
    local rhs = function(rhs_str)
      return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
    end

    local cmp = require "cmp"
    local luasnip = require "luasnip"

    local vs = require "luasnip/loaders/from_vscode"
    vs.lazy_load()

    local kind_icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
    }

    local column = function()
      local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col
    end

    local in_whitespace = function()
      local col = column()
      return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")
    end

    local leading_indent = function()
      local col = column()
      local line = vim.api.nvim_get_current_line()
      local prefix = line:sub(1, col)
      return prefix:find("^%s*$")
    end

    local shift_width = function()
      if vim.o.softtabstop <= 0 then
        return vim.fn.shiftwidth()
      else
        return vim.o.softtabstop
      end
    end

    local smart_bs = function(dedent)
      local keys = nil
      if vim.o.expandtab then
        if dedent then
          keys = rhs("<C-D>")
        else
          keys = rhs("<BS>")
        end
      else
        local col = column()
        local line = vim.api.nvim_get_current_line()
        local prefix = line:sub(1, col)
        if leading_indent() then
          keys = rhs("<BS>")
        else
          local previous_char = prefix:sub(#prefix, #prefix)
          if previous_char ~= " " then
            keys = rhs("<BS>")
          else
            keys = rhs("<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>")
          end
        end
      end
      vim.api.nvim_feedkeys(keys, "nt", true)
    end

    local smart_tab = function(opts)
      local keys = nil
      if vim.o.expandtab then
        keys = "<Tab>"
      else
        local col = column()
        local line = vim.api.nvim_get_current_line()
        local prefix = line:sub(1, col)
        local in_leading_indent = prefix:find("^%s*$")
        if in_leading_indent then
          keys = "<Tab>"
        else
          local sw = shift_width()
          local previous_char = prefix:sub(#prefix, #prefix)
          local previous_column = #prefix - #previous_char + 1
          local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
          local remainder = (current_column - 1) % sw
          local move = remainder == 0 and sw or sw - remainder
          keys = (" "):rep(move)
        end
      end

      vim.api.nvim_feedkeys(rhs(keys), "nt", true)
    end

    -- https://github.com/hrsh7th/nvim-cmp/issues/1716
    local confirm = function(entry)
      local behavior = cmp.ConfirmBehavior.Replace
      if entry then
        local completion_item = entry.completion_item
        local newText = ""
        if completion_item.textEdit then
          newText = completion_item.textEdit.newText
        elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
          newText = completion_item.insertText
        else
          newText = completion_item.word or completion_item.label or ""
        end

        local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col

        if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
          behavior = cmp.ConfirmBehavior.Insert
        end
      end
      cmp.confirm({ select = true, behavior = behavior })
    end

    cmp.setup({
      completion = {
        autocomplete = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<BS>"] = cmp.mapping(function(fallback)
          smart_bs()
        end, { "i", "s" }),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<Esc>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            confirm(entry)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entries = cmp.get_entries()
            if #entries == 1 then
              confirm(entries[1])
            else
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif in_whitespace() then
            smart_tab()
          else
            cmp.complete()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.in_snippet() and luasnip.jumpable(-1) then
            luasnip.jump(-1)
          elseif leading_indent() then
            smart_bs(true)
          elseif in_whitespace() then
            smart_bs()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        max_width = 0,
        format = function(entry, vim_item)
          vim_item.menu = ({
            nvim_lsp = "",
            nvim_lua = "",
            luasnip = "",
            buffer = "",
            path = "",
            emoji = "",
          })[entry.source.name]
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
          vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
          return vim_item
        end,
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.order,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
        },
      },
    })

    local autopairs = require "nvim-autopairs"
    autopairs.setup({
      check_ts = true,
      disable_filetype = { "TelescopePrompt" },
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = true,
      },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    })
  end,
}
