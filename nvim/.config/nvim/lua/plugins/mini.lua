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

      local signs = {
        ERROR = "%#MiniStatuslineDiagnosticError#  %#MiniStatuslineDevinfo#",
        WARN = "%#MiniStatuslineDiagnosticWarn#  %#MiniStatuslineDevinfo#",
        INFO = "%#MiniStatuslineDiagnosticInfo#  %#MiniStatuslineDevinfo#",
        HINT = "%#MiniStatuslineDiagnosticHint#󰌶 %#MiniStatuslineDevinfo#",
      }

      local opts_diag = { trunc_width = 75, icon = "", signs = signs }

      local hl_filename_prefix = "%#MiniStatuslineFilename# "
      local hl_diff_prefix = "%#MiniStatuslineDevinfo# "
      local hl_diff_empty = "%#MiniStatuslineDevinfo#"
      local hl_meta_prefix = "%#MiniStatuslineDevinfo# "
      local hl_meta_empty = "%#MiniStatuslineDevinfo#"

      local sec_location = "%#MiniStatuslineFileinfo# %l:%c "
      local sec_progress = "%#MiniStatuslineModeNormal# %p%% "

      local api = vim.api
      local get_opt = api.nvim_get_option_value
      local get_win_width = api.nvim_win_get_width
      local vim_b = vim.b
      local vim_o = vim.o
      local laststatus_static = vim_o.laststatus
      local section_diagnostics = mini_statusline.section_diagnostics

      local function build_statusline()
        local win_width = laststatus_static == 3 and vim_o.columns or get_win_width(0)

        local cur_buf = api.nvim_get_current_buf()
        local buftype = get_opt("buftype", { buf = cur_buf })

        local filename
        if buftype == "terminal" then
          filename = "%t"
        elseif win_width < 140 then
          filename = "%f%m%r"
        else
          filename = "%F%m%r"
        end

        local diff = ""
        local diagnostics = ""
        if win_width >= 75 then
          local summary = vim_b.minidiff_summary_string or vim_b.gitsigns_status
          if summary and summary ~= "" then
            diff = summary
          end
          diagnostics = section_diagnostics(opts_diag)
        end

        local branch = ""
        if win_width >= 40 then
          local summary = vim_b.minigit_summary_string or vim_b.gitsigns_head
          if summary and summary ~= "" then
            branch = "  " .. summary
          end
        end

        local sec_meta
        if diagnostics ~= "" and branch ~= "" then
          sec_meta = hl_meta_prefix .. diagnostics .. " " .. branch .. " "
        elseif diagnostics ~= "" then
          sec_meta = hl_meta_prefix .. diagnostics .. " "
        elseif branch ~= "" then
          sec_meta = hl_meta_prefix .. branch .. " "
        else
          sec_meta = hl_meta_empty
        end

        return hl_filename_prefix
          .. filename
          .. " "
          .. (diff ~= "" and (hl_diff_prefix .. diff .. " ") or hl_diff_empty)
          .. "%<%="
          .. sec_meta
          .. sec_location
          .. sec_progress
      end

      mini_statusline.setup({
        content = {
          active = build_statusline,
        },
        use_icons = true,
      })
    end,
  },
}
