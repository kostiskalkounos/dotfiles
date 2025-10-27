local env = vim.env
local fn = vim.fn
local fs = vim.fs
local keymap = vim.keymap

local handlers = require("config.handlers")
local jdtls = require("jdtls")
local jdtls_dap = require("jdtls.dap")
local jdtls_tests = require("jdtls.tests")
local opts = { noremap = true, silent = true }

local mason = env.HOME .. "/.local/share/nvim/mason"
local project_name = fn.fnamemodify(fn.getcwd(), ":p:h:t")
local workspace_dir = env.HOME .. "/.local/share/eclipse/" .. project_name

local bundles = {}
local debug_jar = mason .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"
if vim.uv.fs_stat(debug_jar) then
  table.insert(bundles, debug_jar)
end

local exclude = {
  ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
  ["jacocoagent.jar"] = true,
}

for _, jar in ipairs(fn.glob(mason .. "/share/java-test/*.jar", true, true)) do
  if not exclude[fs.basename(jar)] then
    table.insert(bundles, jar)
  end
end

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
    "-javaagent:" .. mason .. "/share/jdtls/lombok.jar",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    mason .. "/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
    "-configuration",
    mason .. "/packages/jdtls/config_mac",
    "-data",
    workspace_dir,
  },
  root_dir = fs.root(0, { ".git", "mvnw", "gradlew" }),
  settings = {
    java = {
      autobuild = { enabled = false },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- runtimes = {
        --   {
        --     name = "JavaSE-25",
        --     path = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home",
        --     default = true,
        --   },
        -- },
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

  keymap.set("n", "<F9>", jdtls.test_class, opts)
  keymap.set("n", "<F10>", jdtls.test_nearest_method, opts)
  keymap.set("n", "<leader><Tab>", jdtls_tests.goto_subjects, opts)
  keymap.set("n", "<leader><S-Tab>", jdtls_tests.generate, opts)
end

jdtls.start_or_attach(config)
