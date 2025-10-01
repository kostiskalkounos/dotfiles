return {
  "nvim-neotest/neotest",
  event = "VeryLazy",
  dependencies = {
    "antoinemadec/FixCursorHold.nvim",
    "fredrikaverpil/neotest-golang",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = function()
    return {
      {
        "<leader>Tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
      },
      {
        "<leader>TT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
      },
      {
        "<leader>Tr",
        function()
          require("neotest").run.run()
        end,
      },
      {
        "<leader>TW",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
      },
      {
        "<leader>Tl",
        function()
          require("neotest").run.run_last()
        end,
      },
      {
        "<leader>Ts",
        function()
          require("neotest").summary.toggle()
        end,
      },
      {
        "<leader>TO",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
      },
      {
        "<leader>To",
        function()
          require("neotest").output_panel.toggle()
        end,
      },
      {
        "<leader>TS",
        function()
          require("neotest").run.stop()
        end,
      },
    }
  end,
  opts = {
    floating = { border = "single" },
    status = { virtual_text = true },
    output = { open_on_run = true },
    summary = { mappings = { jumpto = "<CR>" } },
    output_panel = {
      open = "botright vsplit | vertical resize 80",
    },
    adapters = {
      ["neotest-golang"] = {
        dap_go_enabled = true,
      },
    },
  },
  config = function(_, opts)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    if opts.adapters then
      local adapters = {}
      for name, config in pairs(opts.adapters or {}) do
        if type(name) == "number" then
          if type(config) == "string" then
            config = require(config)
          end
          adapters[#adapters + 1] = config
        elseif config ~= false then
          local adapter = require(name)
          if type(config) == "table" and not vim.tbl_isempty(config) then
            local meta = getmetatable(adapter)
            if adapter.setup then
              adapter.setup(config)
            elseif adapter.adapter then
              adapter.adapter(config)
              adapter = adapter.adapter
            elseif meta and meta.__call then
              adapter = adapter(config)
            else
              error("Adapter " .. name .. " does not support setup")
            end
          end
          adapters[#adapters + 1] = adapter
        end
      end
      opts.adapters = adapters
    end

    require("neotest").setup(opts)
  end,
}
