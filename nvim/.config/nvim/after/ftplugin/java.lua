local fn = vim.fn
local handlers = require("config.handlers")
local jdtls = require("jdtls")
local lsp_util = require("lspconfig.util")
local mason_share = vim.env.HOME .. "/.local/share/nvim/mason/share"
local project_name = fn.fnamemodify(fn.getcwd(), ":t")
local workspace_dir = vim.env.HOME .. "/.local/share/eclipse/" .. project_name

local Iter = require("vim.iter")
local bundles = Iter({
  fn.glob(mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin.jar", true),
  vim.split(fn.glob(mason_share .. "/java-test/*.jar", true), "\n"),
}):flatten():totable()

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
    "-Xmx2g",
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

  root_dir = lsp_util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts")(
    vim.api.nvim_buf_get_name(0)
  ),

  settings = {
    java = {
      autobuild = { enabled = false },
      configuration = { updateBuildConfiguration = "interactive" },
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

local version_patterns = {
  ["pom.xml"] = {
    "<java%.version>([%d.]+)</java%.version>",
    "<maven%.compiler%.source>([%d.]+)</maven%.compiler%.source>",
    "<maven%.compiler%.target>([%d.]+)</maven%.compiler%.target>",
  },
  ["build.gradle"] = {
    "sourceCompatibility%s*=%s*['\"]?(%d+%.?%d*)['\"]?",
    "targetCompatibility%s*=%s*['\"]?(%d+%.?%d*)['\"]?",
    "java%.version%s*=%s*['\"]?(%d+%.?%d*)['\"]?",
  },
  ["build.gradle.kts"] = {
    "sourceCompatibility%s*=%s*JavaVersion%.VERSION_(%d+%.?%d*)",
    "targetCompatibility%s*=%s*JavaVersion%.VERSION_(%d+%.?%d*)",
  },
}

local function getJavaVersion()
  local root_dir = config.root_dir
  if not root_dir then
    return nil
  end

  for filename, patterns in pairs(version_patterns) do
    local path = vim.fs.find(filename, { upward = true, path = root_dir, limit = 1 })[1]
    if path then
      for line in io.lines(path) do
        for _, pattern in ipairs(patterns) do
          local version = line:match(pattern)
          if version then
            return version
          end
        end
      end
    end
  end
  return nil
end

config.on_attach = function()
  local java_version = getJavaVersion()
  if java_version then
    local detected_java_home = vim.trim(fn.system("/usr/libexec/java_home -v " .. java_version))
    if detected_java_home ~= "" and vim.env.JAVA_HOME ~= detected_java_home then
      vim.env.JAVA_HOME = detected_java_home
    end
  end

  handlers.on_attach()

  jdtls.setup_dap({
    hotcodereplace = "auto",
    config_overrides = {},
  })

  local jdtls_dap = require("jdtls.dap")
  local jdtls_tests = require("jdtls.tests")
  jdtls_dap.setup_dap_main_class_configs()

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<F9>", jdtls.test_class, opts)
  vim.keymap.set("n", "<F10>", jdtls.test_nearest_method, opts)
  vim.keymap.set("n", "<leader><Tab>", jdtls_tests.goto_subjects, opts)
end

jdtls.start_or_attach(config)
