return {
  {
    "nvim-mini/mini.icons",
    version = "*",
    event = "VeryLazy",
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("lazy").load({ plugins = { "mini.icons" } })
        local mini_icons = require("mini.icons")
        mini_icons.mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-mini/mini.pairs",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.statusline",
    version = "*",
    event = "UIEnter",
    priority = 999,
    config = function()
      local mini_statusline = require("mini.statusline")

      local EMPTY = ""
      local SPACE = " "
      local FILENAME = "%f%( %m%r%)"
      local LOCATION = " %l:%c "
      local PROGRESS = "%p%%"
      local SEPARATOR = "%<%="
      local BRANCH_ICON = "  "

      local HL_ACTIVE = "%#MiniStatusline#"
      local HL_INACTIVE = "%#MiniStatuslineInactive#"
      local HL_ERROR = "%#MiniStatuslineDiagnosticError#"
      local HL_WARN = "%#MiniStatuslineDiagnosticWarn#"
      local HL_INFO = "%#MiniStatuslineDiagnosticInfo#"
      local HL_HINT = "%#MiniStatuslineDiagnosticHint#"

      local signs = {
        ERROR = HL_ERROR .. "  " .. HL_ACTIVE,
        WARN = HL_WARN .. "  " .. HL_ACTIVE,
        INFO = HL_INFO .. "  " .. HL_ACTIVE,
        HINT = HL_HINT .. "󰌶 " .. HL_ACTIVE,
      }

      local ACTIVE_PREFIX = HL_ACTIVE .. FILENAME
      local INACTIVE_PREFIX = HL_INACTIVE .. FILENAME

      local opts_diag = { icon = EMPTY, signs = signs }
      local section_diagnostics = mini_statusline.section_diagnostics

      local PLUS_REPL = HL_HINT:gsub("%%", "%%%%") .. "%1" .. HL_ACTIVE:gsub("%%", "%%%%")
      local TILDE_REPL = HL_WARN:gsub("%%", "%%%%") .. "%1" .. HL_ACTIVE:gsub("%%", "%%%%")
      local MINUS_REPL = HL_ERROR:gsub("%%", "%%%%") .. "%1" .. HL_ACTIVE:gsub("%%", "%%%%")

      local parts = {}

      local function build_statusline()
        local b = vim.b[0]
        parts[1] = ACTIVE_PREFIX

        local status = b.gitsigns_status
        parts[2] = (status and status ~= EMPTY)
            and (SPACE .. status:gsub("%+%d+", PLUS_REPL):gsub("~%d+", TILDE_REPL):gsub("%-%d+", MINUS_REPL))
          or EMPTY

        parts[3] = SEPARATOR
        parts[4] = section_diagnostics(opts_diag)

        local head = b.gitsigns_head
        parts[5] = (head and head ~= EMPTY) and (BRANCH_ICON .. head) or EMPTY
        parts[6] = LOCATION
        parts[7] = PROGRESS

        return table.concat(parts)
      end

      local function build_statusline_inactive()
        return INACTIVE_PREFIX
      end

      mini_statusline.setup({
        content = {
          active = build_statusline,
          inactive = build_statusline_inactive,
        },
        use_icons = true,
      })
    end,
  },
}
