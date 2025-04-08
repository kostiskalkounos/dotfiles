return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    actions = { open_file = { resize_window = false } },
    update_focused_file = { enable = true, update_cwd = false },
    filters = { custom = { ["^.git$"] = true, ["node_modules"] = true } }
  },
  config = function(_, o)
    local v, a, r = require "nvim-tree.view", require "nvim-tree.api", vim.api
    r.nvim_create_augroup("s", { clear = true })
    r.nvim_create_autocmd("WinResized", {
      group = "s",
      pattern = "*",
      callback = function()
        local w = v.get_winnr()
        if w and vim.tbl_contains(vim.v.event.windows, w) then
          vim.t.w = r.nvim_win_get_width(w)
        end
      end
    })
    a.events.subscribe(a.events.Event.TreeOpen, function()
      if vim.t.w then v.resize(vim.t.w) end
    end)
    require "nvim-tree".setup(o)
  end
}
