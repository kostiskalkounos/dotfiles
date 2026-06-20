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
      local HL_ADD = "%#MiniStatuslineAdd#"
      local HL_ERROR = "%#MiniStatuslineDiagnosticError#"
      local HL_HINT = "%#MiniStatuslineDiagnosticHint#"
      local HL_INACTIVE = "%#MiniStatuslineInactive#"
      local HL_INFO = "%#MiniStatuslineDiagnosticInfo#"
      local HL_WARN = "%#MiniStatuslineDiagnosticWarn#"

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

      local b = vim.b
      local parts = {}

      local function build_statusline()
        parts[1] = ACTIVE_PREFIX

        local git_dict = b.gitsigns_status_dict
        if git_dict then
          local git_parts = {}
          if git_dict.added and git_dict.added > 0 then
            git_parts[#git_parts + 1] = HL_ADD .. "+" .. git_dict.added .. HL_ACTIVE
          end
          if git_dict.changed and git_dict.changed > 0 then
            git_parts[#git_parts + 1] = HL_WARN .. "~" .. git_dict.changed .. HL_ACTIVE
          end
          if git_dict.removed and git_dict.removed > 0 then
            git_parts[#git_parts + 1] = HL_ERROR .. "-" .. git_dict.removed .. HL_ACTIVE
          end

          if #git_parts > 0 then
            parts[2] = SPACE .. table.concat(git_parts, SPACE)
          else
            parts[2] = EMPTY
          end
        else
          parts[2] = EMPTY
        end

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
