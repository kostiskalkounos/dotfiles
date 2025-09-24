local fn = vim.fn
local handlers = require("config.handlers")
local jdtls = require("jdtls")
local jdtls_dap = require("jdtls.dap")
local jdtls_tests = require("jdtls.tests")
local opts = { noremap = true, silent = true }

local mason_share = vim.env.HOME .. "/.local/share/nvim/mason/share"
local project_name = fn.fnamemodify(fn.getcwd(), ":p:h:t")
local workspace_dir = vim.env.HOME .. "/.local/share/eclipse/" .. project_name

local bundles = vim
  .iter({
    fn.glob(mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin.jar", true),
    vim.split(fn.glob(mason_share .. "/java-test/*.jar", true), "\n"),
  })
  :flatten()
  :totable()

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=WARNING",
    "-javaagent:" .. mason_share .. "/jdtls/lombok.jar",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    mason_share .. "/jdtls/plugins/org.eclipse.equinox.launcher.jar",
    "-configuration",
    mason_share .. "/../packages/jdtls/config_mac",
    "-data",
    workspace_dir,
  },
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
  settings = {
    java = {
      autobuild = { enabled = false },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          { name = "JavaSE-1.8", path = "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home" },
          { name = "JavaSE-17", path = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home" },
          { name = "JavaSE-21", path = "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home" },
          {
            name = "JavaSE-25",
            path = "/Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home",
            default = true,
          },
        },
      },
      contentProvider = { preferred = "fernflower" },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      maxConcurrentBuilds = 2,
      implementationsCodeLens = { enabled = false },
      referencesCodeLens = { enabled = false },
      references = { includeDecompiledSources = true },
      format = { enabled = true },
      saveActions = { organizeImports = false },
      signatureHelp = { enabled = true },
    },
    completion = {
      maxResults = 20,
      importOrder = { "java", "javax", "com", "org" },
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        useBlocks = true,
      },
    },
  },

  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 150,
  },

  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
}

config.on_attach = function()
  handlers.on_attach()

  jdtls.setup_dap({
    hotcodereplace = "auto",
    config_overrides = {},
  })

  jdtls_dap.setup_dap_main_class_configs()

  vim.keymap.set("n", "<F9>", jdtls.test_class, opts)
  vim.keymap.set("n", "<F10>", jdtls.test_nearest_method, opts)
  vim.keymap.set("n", "<leader><Tab>", jdtls_tests.goto_subjects, opts)
  vim.keymap.set("n", "<leader><S-Tab>", jdtls_tests.generate, opts)
end

jdtls.start_or_attach(config)
