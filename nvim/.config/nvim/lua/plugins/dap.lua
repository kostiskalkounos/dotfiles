return {
  {
    "mfussenegger/nvim-dap",
    cmd = "DapContinue",
    dependencies = {
      { "leoluz/nvim-dap-go" },
      { "nvim-neotest/nvim-nio" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "williamboman/mason.nvim" },
    },
    config = function()
      -- vim.fn.sign_define("DapBreakpointCondition", { text = "ü", texthl = "", linehl = "", numhl = "" })
      -- vim.fn.sign_define("DapStopped", { text = "ඞ", texthl = "Error" })

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

      require("nvim-dap-virtual-text").setup({
        enabled = true,

        -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
        enabled_commands = false,

        -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_changed_variables = true,
        highlight_new_as_changed = true,

        -- prefix virtual text with comment string
        commented = false,

        show_stop_reason = true,

        -- experimental features:
        virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
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
            local value = vim.fn.input("Host [127.0.0.1]: ")
            if value ~= "" then
              return value
            end
            return "127.0.0.1"
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
          name = "Debug Launch (2GB)",
          type = "java",
          request = "launch",
          vmArgs = "" .. "-Xmx2g ",
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
          name = "My Custom Java Run Configuration",
          type = "java",
          request = "launch",
          -- You need to extend the classPath to list your dependencies.
          -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
          -- classPaths = {},

          -- If using multi-module projects, remove otherwise.
          -- projectName = "yourProjectName",

          -- javaExec = "java",
          mainClass = "replace.with.your.fully.qualified.MainClass",

          -- If using the JDK9+ module system, this needs to be extended
          -- `nvim-jdtls` would automatically populate this property
          -- modulePaths = {},
          vmArgs = "" .. "-Xmx2g ",
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
          name = "Debug test", -- configuration for debugging test files
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        -- works with go.mod packages and sub packages
        {
          type = "go",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      -- You can set trigger characters OR it will default to '.'
      -- You can also trigger with the omnifunc, <c-x><c-o>
      vim.cmd([[
        augroup DapRepl
          au!
          au FileType dap-repl lua require('dap.ext.autocompl').attach()
        augroup END
      ]])

      local dap_ui = require("dapui")

      local _ = dap_ui.setup({
        layouts = {
          {
            elements = {
              "scopes",
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 10,
            position = "bottom",
          },
        },
        -- -- You can change the order of elements in the sidebar
        -- sidebar = {
        --   elements = {
        --     -- Provide as ID strings or tables with "id" and "size" keys
        --     {
        --       id = "scopes",
        --       size = 0.75, -- Can be float or integer > 1
        --     },
        --     { id = "watches", size = 00.25 },
        --   },
        --   size = 50,
        --   position = "left", -- Can be "left" or "right"
        -- },
        --
        -- tray = {
        --   elements = {},
        --   size = 15,
        --   position = "bottom", -- Can be "bottom" or "top"
        -- },
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
