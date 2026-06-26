return {
  "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
  build = ":TSUpdate",
  dependencies = { { "windwp/nvim-ts-autotag", opts = {} } },
  config = function()
    local ts = require("nvim-treesitter")

    local api = vim.api
    local list_contains = vim.list_contains
    local nvim_buf_get_offset = api.nvim_buf_get_offset
    local nvim_buf_line_count = api.nvim_buf_line_count
    local nvim_create_augroup = api.nvim_create_augroup
    local nvim_create_autocmd = api.nvim_create_autocmd
    local nvim_set_option_value = api.nvim_set_option_value
    local schedule = vim.schedule
    local vim_ts = vim.treesitter

    ts.setup()

    local parsers = {
      "bash",
      "c",
      "cpp",
      "css",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitcommit",
      "go",
      "groovy",
      "html",
      "java",
      "javascript",
      "json",
      "lua",
      "nix",
      "python",
      "rust",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "xml",
      "yaml",
    }

    schedule(function()
      local installed = ts.get_installed()
      local missing = {}
      for _, p in ipairs(parsers) do
        if not list_contains(installed, p) then
          table.insert(missing, p)
        end
      end

      if #missing > 0 then
        ts.install(missing)
      end
    end)

    local function should_disable(buf)
      local line_count = nvim_buf_line_count(buf)
      return line_count > 5000 or nvim_buf_get_offset(buf, line_count) > 102400
    end

    local parser_cache = setmetatable({}, {
      __index = function(t, lang)
        local ok = not not vim_ts.language.add(lang)
        t[lang] = ok
        return ok
      end,
    })

    local ts_group = nvim_create_augroup("CustomTreesitterSetup", { clear = true })
    nvim_create_autocmd("FileType", {
      group = ts_group,
      pattern = "*",
      callback = function(args)
        local buf = args.buf
        if should_disable(buf) then
          return
        end

        local ft = args.match
        if not ft or ft == "" then
          return
        end

        local lang = vim_ts.language.get_lang(ft) or ft
        if lang and parser_cache[lang] then
          vim_ts.start(buf, lang)
          nvim_set_option_value("indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", { buf = buf })
        end
      end,
    })
  end,
}
