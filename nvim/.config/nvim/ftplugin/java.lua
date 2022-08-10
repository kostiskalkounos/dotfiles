WORKSPACE_PATH = os.getenv("HOME") .. "/Projects/"
CONFIG = "mac"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

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
    vim.fn.glob("/usr/local/Cellar/jdtls/1.14.0/libexec/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    "/usr/local/Cellar/jdtls/1.14.0/libexec/config_mac",
    "-data",
    workspace_dir,
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
  settings = {
    java = {
      format = {
        enabled = false,
      },
    },
  },

  init_options = {
    bundles = {},
  },
}
require("jdtls").start_or_attach(config)
