local bit = require("bit")
local jdtls = require("jdtls")

local fs = vim.fs
local uv = vim.uv

local bxor, lshift, tohex = bit.bxor, bit.lshift, bit.tohex

local home = os.getenv("HOME") or ""
local mason = home .. "/.local/share/nvim/mason"
local root_dir = fs.root(0, { ".git", "mvnw", "gradlew" }) or uv.cwd()
local project_name = fs.basename(root_dir)

local function djb2(str)
  local hash = 5381
  for i = 1, #str do
    hash = bxor(lshift(hash, 5) + hash, str:byte(i))
  end
  return tohex(hash)
end

local workspace_hash = djb2(root_dir)
local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name .. "-" .. workspace_hash

if not _G._jdtls_bundles then
  local bundles = {}
  local debug_jar = mason .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"
  if uv.fs_stat(debug_jar) then
    table.insert(bundles, debug_jar)
  end

  local exclude = {
    ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
    ["jacocoagent.jar"] = true,
  }

  local test_dir = mason .. "/share/java-test"
  if uv.fs_stat(test_dir) then
    for name, type in fs.dir(test_dir) do
      if (type == "file" or type == "link") and name:sub(-4) == ".jar" and not exclude[name] then
        table.insert(bundles, test_dir .. "/" .. name)
      end
    end
  end
  table.sort(bundles)
  _G._jdtls_bundles = bundles
end

local bundles = _G._jdtls_bundles
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
  root_dir = root_dir,
  settings = {
    java = {
      autobuild = { enabled = false },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- runtimes = {
        --   {
        --     name = "JavaSE-26",
        --     path = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home",
        --     default = true,
        --   },
        --   {
        --     name = "JavaSE-26",
        --     path = "/Library/Java/JavaVirtualMachines/temurin-26.jdk/Contents/Home",
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

local function jdtls_goto_subjects()
  require("jdtls.tests").goto_subjects()
end

local function jdtls_generate()
  require("jdtls.tests").generate()
end

config.on_attach = function(_, bufnr)
  jdtls.setup_dap({
    hotcodereplace = "auto",
    config_overrides = {},
  })

  require("jdtls.dap").setup_dap_main_class_configs()

  local set = vim.keymap.set
  local opts = { silent = true, buffer = bufnr }

  set("n", "<F9>", jdtls.test_class, opts)
  set("n", "<F10>", jdtls.test_nearest_method, opts)
  set("n", "<leader><Tab>", jdtls_goto_subjects, opts)
  set("n", "<leader><S-Tab>", jdtls_generate, opts)
end

jdtls.start_or_attach(config)
