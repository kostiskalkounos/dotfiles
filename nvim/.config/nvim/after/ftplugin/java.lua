local jdtls = require("jdtls")
local root_markers = { vim.fn.getcwd() }
local root_dir = require("jdtls.setup").find_root(root_markers)
local home = os.getenv("HOME")
local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local jar_patterns = {
  "~/Projects/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
  "~/Projects/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar",
  "~/Projects/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar",
  "~/Projects/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar",
}

local plugin_path =
  "~/Projects/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/"
local bundle_list = vim.tbl_map(function(x)
  return require("jdtls.path").join(plugin_path, x)
end, {
  "junit-jupiter-*.jar",
  "junit-platform-*.jar",
  "junit-vintage-engine_*.jar",
  "org.opentest4j*.jar",
  "org.apiguardian.api_*.jar",
  "org.eclipse.jdt.junit4.runtime_*.jar",
  "org.eclipse.jdt.junit5.runtime_*.jar",
  "org.opentest4j_*.jar",
})

vim.list_extend(jar_patterns, bundle_list)
local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), "\n")) do
    if
      not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
      and not vim.endswith(bundle, "com.microsoft.java.test.runner.jar")
    then
      table.insert(bundles, bundle)
    end
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
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob("/usr/local/Cellar/jdtls/*/libexec/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    vim.fn.glob("/usr/local/Cellar/jdtls/*/libexec/config_mac"),
    "-data",
    workspace_dir,
  },
  java = {
    eclipse = {
      downloadSources = true,
    },
    configuration = {
      updateBuildConfiguration = "interactive",
    },
    maven = {
      downloadSources = true,
    },
    implementationsCodeLens = {
      enabled = true,
    },
    referencesCodeLens = {
      enabled = true,
    },
    references = {
      includeDecompiledSources = true,
    },
    inlayHints = {
      parameterNames = {
        enabled = "all", -- literals, all, none
      },
    },
    format = {
      enabled = false,
    },
  },
  signatureHelp = { enabled = true },
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
  },
  contentProvider = { preferred = "fernflower" },
  extendedClientCapabilities = extendedClientCapabilities,
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
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = bundles,
  },
  handlers = { ["language/status"] = function() end },
}

local default = { noremap = true, silent = true }
vim.keymap.set("n", "<F9>", ":lua require'jdtls'.test_class()<CR>", default)
vim.keymap.set("n", "<F10>", ":lua require'jdtls'.test_nearest_method()<CR>", default)

require("jdtls").setup_dap({ hotcodereplace = "auto" })
require("jdtls").setup.add_commands()

jdtls.start_or_attach(config)
