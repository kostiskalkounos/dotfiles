return {
  {
    "nvim-mini/mini.icons",
    event = "VeryLazy",
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
}
