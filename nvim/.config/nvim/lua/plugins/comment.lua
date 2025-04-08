return {
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb", "gcc", "gbc", "v", "V", "<C-v>" },
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require "Comment".setup({
        pre_hook = function(ctx)
          local U = require "Comment.utils"
          local ts_utils = require "ts_context_commentstring.utils"
          local ts_internal = require "ts_context_commentstring.internal"

          local location = ctx.ctype == U.ctype.block and ts_utils.get_cursor_location()
              or (ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V) and ts_utils.get_visual_start_location()
              or nil

          return ts_internal.calculate_commentstring({
            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location,
          })
        end,
      })

      require "ts_context_commentstring".setup({ enable_autocmd = false })
    end,
  },
}
