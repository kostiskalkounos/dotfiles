return {
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb", "gcc", "gbc", "v", "V", "<C-v>" },
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      local c = require("Comment")
      c.setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
        },
        post_hook = nil,

        pre_hook = function(ctx)
          local U = require("Comment.utils")
          local ts_utils = require("ts_context_commentstring.utils")
          local ts_internal = require("ts_context_commentstring.internal")

          local ctype = ctx.ctype == U.ctype.blockwise and "__multiline" or "__default"
          local location = nil

          if ctx.ctype == U.ctype.blockwise then
            location = ts_utils.get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = ts_utils.get_visual_start_location()
          end

          return ts_internal.calculate_commentstring({
            key = ctype,
            location = location,
          }) or "//"
        end,
      })

      local t = require("ts_context_commentstring")
      t.setup({ enable_autocmd = false })
    end,
  },
}
