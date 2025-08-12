return {
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = true,
        custom_commentstring = function(ctx)
          return require("ts_context_commentstring.internal").calculate_commentstring(ctx) or vim.bo.commentstring
        end,
      })

      require("Comment").setup({
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
        pre_hook = nil,
        post_hook = nil,
      })
    end,
  },
}
