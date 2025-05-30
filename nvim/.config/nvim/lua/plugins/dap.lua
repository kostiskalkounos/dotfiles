return {
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapContinue", "DapToggleBreakpoint", "DapStepOver", "DapStepInto", "DapStepOut" },
    dependencies = {
      "leoluz/nvim-dap-go",
      "nvim-neotest/nvim-nio",
      "nvim-telescope/telescope-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
    },
    config = function()
      local fn = vim.fn

      fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "", linehl = "", numhl = "" })
      fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" })
      fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      local virt_text = require("nvim-dap-virtual-text")
      virt_text.setup({
        all_frames = false,
        all_references = false,
        clear_on_continue = false,
        commented = false,
        enable_commands = false,
        enabled = true,
        enabled_commands = false,
        filter_references_pattern = "",
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        only_first_definition = true,
        show_stop_reason = true,
        text_prefix = "",
        separator = ",",
        error_prefix = "  ",
        info_prefix = "  ",
        virt_lines = false,
        virt_lines_above = false,
        virt_text_pos = "eol",

        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value:gsub("%s+", " ")
          else
            return variable.name .. " = " .. variable.value:gsub("%s+", " ")
          end
        end,
      })

      local dap = require("dap")
      local dap_repl = require("dap.repl")

      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Neovim attach",
          host = function()
            return fn.input("Host [127.0.0.1]: ") or "127.0.0.1"
          end,
          port = function()
            local val = tonumber(fn.input("Port: "))
            assert(val, "Please provide a port number")
            return val
          end,
        },
      }

      dap.configurations.java = {
        {
          name = "Debug Launch (2GB)",
          type = "java",
          request = "launch",
          vmArgs = "-Xmx4g ",
        },
        {
          name = "Debug Attach (5005)",
          type = "java",
          request = "attach",
          hostName = "127.0.0.1",
          port = 5005,
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
          -- classPaths = {},
          -- projectName = "yourProjectName",
          -- javaExec = "java",
          mainClass = "replace.with.your.fully.qualified.MainClass",
          -- modulePaths = {},
          vmArgs = "-Xmx4g ",
        },
      }

      dap.adapters.go = function(callback, _)
        local stdout = vim.loop.new_pipe(false)
        local handle
        local pid_or_err
        local port = 38697
        local opts = {
          stdio = { nil, stdout },
          args = { "dap", "-l", "127.0.0.1:" .. port },
          detached = true,
        }
        handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
          stdout:close()
          handle:close()
          if code ~= 0 then
            print("dlv exited with code", code)
          end
        end)
        assert(handle, "Error running dlv: " .. tostring(pid_or_err))
        stdout:read_start(function(err, chunk)
          assert(not err, err)
          if chunk then
            vim.schedule(function()
              dap_repl.append(chunk)
            end)
          end
        end)
        -- Wait for delve to start
        vim.defer_fn(function()
          callback({ type = "server", host = "127.0.0.1", port = port })
        end, 100)
      end

      -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug with args",
          request = "launch",
          program = "${file}",
          args = function()
            local argument_string = fn.input("Program arg(s): ")
            return fn.split(argument_string, " ", true)
          end,
        },
        {
          type = "go",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function()
          local d = require("dap.ext.autocompl")
          d.attach()
        end,
      })

      local dap_ui = require("dapui")

      dap_ui.setup({
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
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40,
            position = "left",
          },
          {
            elements = { "repl", "console" },
            size = 10,
            position = "bottom",
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

      dap.listeners.before.attach.dapui_config = function()
        dap_ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dap_ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dap_ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dap_ui.close()
      end

      local dap_go = require("dap-go")
      dap_go.setup()

      local default = { noremap = true, unique = true, silent = true }
      local set = vim.keymap.set

      set("n", "<F1>", function()
        dap.continue()
      end, default)
      set("n", "<F2>", function()
        dap.step_over()
      end, default)
      set("n", "<F3>", function()
        dap.step_into()
      end, default)
      set("n", "<F4>", function()
        dap.step_out()
      end, default)
      set("n", "<F5>", function()
        dap.step_back()
      end, default)
      set("n", "<F6>", function()
        dap_repl.toggle()
      end, default)
      set("n", "<F7>", function()
        dap.toggle_breakpoint()
      end, default)
      set("n", "<F8>", function()
        dap.set_breakpoint(fn.input("Breakpoint condition: "))
      end, default)
    end,
  },
}
