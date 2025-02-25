return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeClose", "NvimTreeRefresh" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local view = require("nvim-tree.view")
    local api = require("nvim-tree.api")

    vim.api.nvim_create_augroup("save_nvim_tree_width", { clear = true })
    vim.api.nvim_create_autocmd("WinResized", {
      group = "save_nvim_tree_width",
      pattern = "*",
      callback = function()
        local filetree_winnr = view.get_winnr()
        if filetree_winnr ~= nil and vim.tbl_contains(vim.v.event["windows"], filetree_winnr) then
          vim.t["filetree_width"] = vim.api.nvim_win_get_width(filetree_winnr)
        end
      end,
    })

    api.events.subscribe(api.events.Event.TreeOpen, function()
      if vim.t["filetree_width"] ~= nil then
        view.resize(vim.t["filetree_width"])
      end
    end)

    require("nvim-tree").setup({
      actions = {
        open_file = {
          resize_window = false,
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = false,
      },
      filters = {
        custom = { "^.git$", "node_modules" },
      },
      -- view = {
      --   float = {
      --     enable = true,
      --     open_win_config = function()
      --       local screen_w = vim.opt.columns:get()
      --       local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
      --       local window_w = screen_w * 0.5
      --       local window_h = screen_h * 0.5
      --       local window_w_int = math.floor(window_w)
      --       local window_h_int = math.floor(window_h)
      --       local center_x = (screen_w - window_w) / 2
      --       local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
      --       return {
      --         border = "rounded",
      --         relative = "editor",
      --         row = center_y,
      --         col = center_x,
      --         width = window_w_int,
      --         height = window_h_int,
      --       }
      --     end,
      --   },
      --   width = function()
      --     return math.floor(vim.opt.columns:get() * 0.5)
      --   end,
      -- },
    })
  end,
}
