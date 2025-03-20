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
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      require("nvim-dap-virtual-text").setup({
        all_frames = false,
        commented = false,
        enabled = true,
        enabled_commands = false,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        virt_text_pos = "eol",
      })

      local dap = require("dap")

      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Neovim attach",
          host = function()
            return vim.fn.input("Host [127.0.0.1]: ") or "127.0.0.1"
          end,
          port = function()
            local val = tonumber(vim.fn.input("Port: "))
            assert(val, "Please provide a port number")
            return val
          end,
        },
      }

      dap.configurations.java = {
        {
          name = "Debug Launch (4GB)",
          type = "java",
          request = "launch",
          vmArgs = "-Xmx4g ",
          env = function()
            local java_version = require("config.java").getJavaVersion()
            if java_version then
              vim.env.JAVA_HOME = vim.fn.systemlist("/usr/libexec/java_home -v " .. java_version)[1]
            end
          end,
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
              require("dap.repl").append(chunk)
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
            local argument_string = vim.fn.input("Program arg(s): ")
            return vim.fn.split(argument_string, " ", true)
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
          require("dap.ext.autocompl").attach()
        end,
      })

      local dap_ui = require("dapui")

      dap_ui.setup({
        layouts = {
          { elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 40, position = "left" },
          { elements = { "repl", "console" }, size = 10, position = "bottom" },
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

      require("dap-go").setup()
    end,
  },
}
