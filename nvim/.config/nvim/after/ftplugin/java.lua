local jdtls = require("jdtls")
local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(project_name, ":p:h:t")

local bundles = {
  vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    "java",
    --'-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005',
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_mac", -- (config_linux, config_mac, config_win)
    "-data",
    workspace_dir,
  },

  root_dir = require("lspconfig").util.root_pattern(
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts"
  )(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())),

  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      autobuild = {
        enabled = false,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-11",
            path = os.getenv("JDK11"),
          },
          {
            name = "JavaSE-17",
            path = os.getenv("JDK17"),
          },
          {
            name = "JavaSE-21",
            path = os.getenv("JDK21"),
          },
          {
            name = "JavaSE-22",
            path = os.getenv("JDK22"),
          },
          -- {
          --   name = "JavaSE-18",
          --   path = home .. "/.m2/jdks/jdk-18.0.2.1+1/",
          -- },
          -- {
          --   name = "JavaSE-15",
          --   path = home .. "/.sdkman/candidates/java/15.0.1-open/",
          -- },
        },
      },
      contentProvider = {
        preferred = "fernflower",
      },
      eclipse = { downloadSources = true },
      format = {
        enabled = true,
        -- settings = {
        --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
        --   profile = "GoogleStyle",
        -- },
      },
      implementationsCodeLens = {
        enabled = true,
      },
      maven = {
        downloadSources = true,
      },
      maxConcurrentBuilds = 1,
      references = {
        includeDecompiledSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      saveActions = {
        organizeImports = false,
      },
      signatureHelp = {
        enabled = true,
      },
    },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org",
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
}

config["on_attach"] = function(client, bufnr)
  require("config.handlers").on_attach(client, bufnr)

  jdtls.setup.add_commands()
  jdtls.setup_dap({ hotcodereplace = "auto" })
  require("jdtls.dap").setup_dap_main_class_configs()

  local default = { noremap = true, silent = true }
  vim.keymap.set("n", "<F9>", "<cmd>lua require('jdtls').test_class()<CR>", default)
  vim.keymap.set("n", "<F10>", "<cmd>lua require('jdtls').test_nearest_method()<CR>", default)
end

jdtls.start_or_attach(config)
