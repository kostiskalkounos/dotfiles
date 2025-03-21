return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    actions = { open_file = { resize_window = false } },
    update_focused_file = { enable = true, update_cwd = false },
    filters = { custom = { "^.git$", "node_modules" } },
  },
  config = function(_, opts)
    local view = require("nvim-tree.view")
    local api = require("nvim-tree.api")

    vim.api.nvim_create_augroup("save_nvim_tree_width", { clear = true })
    vim.api.nvim_create_autocmd("WinResized", {
      group = "save_nvim_tree_width",
      pattern = "*",
      callback = function()
        local filetree_winnr = view.get_winnr()
        if filetree_winnr and vim.tbl_contains(vim.v.event.windows, filetree_winnr) then
          vim.t.filetree_width = vim.api.nvim_win_get_width(filetree_winnr)
        end
      end,
    })

    api.events.subscribe(api.events.Event.TreeOpen, function()
      if vim.t.filetree_width then
        view.resize(vim.t.filetree_width)
      end
    end)

    require("nvim-tree").setup(opts)
  end,
}
