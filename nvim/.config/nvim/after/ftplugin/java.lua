local jdtls = require("jdtls")
local handlers = require("config.handlers")
local home = os.getenv("HOME")
local root_pattern = require("lspconfig").util.root_pattern
local mason_share = home .. "/.local/share/nvim/mason/share"

local java_homes = {}
local function get_java_home(version)
  if not java_homes[version] then
    java_homes[version] = vim.fn.trim(vim.fn.system("/usr/libexec/java_home -v " .. version))
  end
  return java_homes[version]
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

local function get_bundles()
  return vim.tbl_flatten({
    vim.fn.glob(mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin.jar", 1),
    vim.fn.split(vim.fn.glob(mason_share .. "/java-test/*.jar", 1), "\n"),
  })
end

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
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
    home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
    "-data",
    workspace_dir,
  },

  root_dir = root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts")(
    vim.api.nvim_buf_get_name(0)
  ),

  settings = {
    java = {
      autobuild = { enabled = false },
      configuration = {
        updateBuildConfiguration = "automatic",
        runtimes = {
          { name = "JavaSE-23", path = get_java_home("23") },
          { name = "JavaSE-17", path = get_java_home("17") },
          { name = "JavaSE-1.8", path = get_java_home("1.8") },
        },
      },
      contentProvider = { preferred = "fernflower" },
      eclipse = { downloadSources = true },
      format = { enabled = true },
      implementationsCodeLens = { enabled = true },
      maven = { downloadSources = true },
      maxConcurrentBuilds = 4,
      references = { includeDecompiledSources = true },
      referencesCodeLens = { enabled = true },
      saveActions = { organizeImports = false },
      signatureHelp = { enabled = true },
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
      importOrder = { "java", "javax", "com", "org" },
    },
    sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
    codeGeneration = {
      toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
      useBlocks = true,
    },
  },

  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = { allow_incremental_sync = true },
}

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = { extendedClientCapabilities = extendedClientCapabilities }

local function read_version_from_file(filename, patterns, transform)
  local path = vim.fn.findfile(filename, vim.fn.getcwd() .. ";")
  if path == "" then
    return nil
  end

  local content = table.concat(vim.fn.readfile(path), "\n")

  for _, pattern in ipairs(patterns) do
    local version = content:match(pattern)
    if version then
      return transform and transform(version) or version
    end
  end

  return nil
end

local version_patterns = {
  ["pom.xml"] = {
    patterns = {
      "<java%.version>(%d+)</java%.version>",
      "<maven%.compiler%.source>(%d+)</maven%.compiler%.source>",
    },
  },
  ["build.gradle"] = {
    patterns = {
      "sourceCompatibility%s*=%s*['\"]?(1%.%d+)['\"]?",
      "sourceCompatibility%s*=%s*['\"]?(%d+)['\"]?",
    },
    transform = function(v)
      return v:gsub("1%.", "")
    end,
  },
}

local function getJavaVersion()
  for filename, config in pairs(version_patterns) do
    local version = read_version_from_file(filename, config.patterns, config.transform)
    if version then
      return version
    end
  end
  return nil
end

config.on_attach = function(client, bufnr)
  if not config.init_options.bundles then
    config.init_options.bundles = get_bundles()
  end

  local java_version = getJavaVersion()
  if java_version then
    vim.env.JAVA_HOME = get_java_home(java_version)
  end

  handlers.on_attach(client, bufnr)

  jdtls.setup.add_commands()
  jdtls.setup_dap({ hotcodereplace = "auto" })

  local jdtls_dap = require("jdtls.dap")
  jdtls_dap.setup_dap_main_class_configs()

  local opts = { noremap = true, silent = true }
  local set = vim.keymap.set

  set("n", "<F9>", function()
    jdtls.test_class()
  end, opts)
  set("n", "<F10>", function()
    jdtls.test_nearest_method()
  end, opts)
end

jdtls.start_or_attach(config)
