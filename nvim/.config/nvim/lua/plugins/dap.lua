return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "williamboman/mason.nvim",
      {
        "leoluz/nvim-dap-go",
        config = function()
          require("dap-go").setup()
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { virt_text_pos = "eol" },
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local default = { noremap = true, unique = true, silent = true }

      local api = vim.api
      local fn = vim.fn
      local set = vim.keymap.set

      fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" })
      fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      fn.sign_define("DapLogPoint", { text = "󰁕 ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function()
          require("dap.ext.autocompl").attach()
        end,
      })

      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          expand = { "<cr>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_mappings = {},
        expand_lines = true,
        force_buffers = true,
        layouts = {
          {
            position = "left",
            size = 0.30,
            elements = {
              { id = "scopes", size = 0.38 },
              { id = "watches", size = 0.16 },
              { id = "breakpoints", size = 0.18 },
              { id = "stacks", size = 0.28 },
            },
          },
          {
            position = "bottom",
            size = 0.30,
            elements = {
              { id = "repl", size = 0.50 },
              { id = "console", size = 0.50 },
            },
          },
        },

        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          indent = 1,
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
            disconnect = "",
          },
        },
      })

      local function find_window_by_filetype(element)
        for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
          local buf = api.nvim_win_get_buf(win)
          local filetype = vim.bo[buf].filetype

          if filetype == element or (element == "editor" and dap.configurations[filetype]) then
            api.nvim_set_current_win(win)
            return
          end
        end
      end

      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close

      local element_map = {
        S = "dapui_scopes",
        T = "dapui_stacks",
        B = "dapui_breakpoints",
        W = "dapui_watches",
        R = "dap-repl",
        C = "dapui_console",
        E = "editor",
      }

      local keymaps_active = false
      local keymap_opts = { silent = true }

      local function setup_keymaps()
        if not keymaps_active then
          for key, element in pairs(element_map) do
            set("n", key, function()
              find_window_by_filetype(element)
            end, keymap_opts)
          end
          keymaps_active = true
        end
      end

      local function cleanup_keymaps()
        if keymaps_active then
          for key in pairs(element_map) do
            pcall(vim.keymap.del, "n", key)
          end
          keymaps_active = false
        end
      end

      dap.listeners.before.attach.session_keymaps = setup_keymaps
      dap.listeners.before.launch.session_keymaps = setup_keymaps
      dap.listeners.before.event_terminated.session_keymaps = cleanup_keymaps
      dap.listeners.before.event_exited.session_keymaps = cleanup_keymaps

      local debug_maps = {
        ["<F1>"] = dap.step_over,
        ["<F2>"] = dap.step_into,
        ["<F3>"] = dap.step_out,
        ["<F4>"] = dap.step_back,
        ["<F5>"] = dap.continue,
        ["<F6>"] = function()
          dapui.toggle(2)
        end,
        ["<F7>"] = dap.toggle_breakpoint,
        ["<F8>"] = function()
          dap.set_breakpoint(fn.input("Breakpoint condition: "))
        end,
        ["<F12>"] = function()
          dap.set_breakpoint(nil, nil, fn.input("Log point message: "))
        end,
      }

      for key, func in pairs(debug_maps) do
        set("n", key, func, default)
      end

      set({ "n", "v" }, "<leader>:", function()
        dapui.eval(nil, { enter = true })
        vim.defer_fn(function()
          api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end, 50)
      end, default)

      set({ "n", "v" }, "<leader>O", function()
        require("dapui").elements.watches.add()
      end, default)

      dap.configurations.java = {
        {
          name = "Debug Launch (4GB)",
          type = "java",
          request = "launch",
          vmArgs = "-Xmx4g ",
        },
        {
          name = "Debug Attach (8000)",
          type = "java",
          request = "attach",
          hostName = "127.0.0.1",
          port = 8000,
        },
        {
          name = "Debug Attach (8001)",
          type = "java",
          request = "attach",
          hostName = "127.0.0.1",
          port = 8001,
        },
        {
          name = "Debug Attach (8002)",
          type = "java",
          request = "attach",
          hostName = "127.0.0.1",
          port = 8002,
        },
        {
          name = "Debug Non-Project class",
          type = "java",
          request = "launch",
          program = "${file}",
        },
        {
          name = "Custom Java Runnner",
          type = "java",
          request = "launch",
          classPaths = {},
          projectName = "yourProjectName",
          javaExec = "java",
          mainClass = "replace.with.your.fully.qualified.MainClass",
          modulePaths = {},
          vmArgs = "-Xmx4g ",
        },
      }
    end,
  },
}
