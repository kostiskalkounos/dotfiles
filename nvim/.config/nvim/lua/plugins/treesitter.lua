return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = { { "windwp/nvim-ts-autotag", opts = {} } },
  config = function()
    local ts = require("nvim-treesitter")
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
      "markdown",
      "markdown_inline",
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

    for ft, lang in pairs({ typescriptreact = "tsx", javascriptreact = "tsx", jsonc = "json" }) do
      pcall(vim.treesitter.language.register, lang, ft)
    end

    local nvim_buf_is_valid = vim.api.nvim_buf_is_valid
    local nvim_get_option_value = vim.api.nvim_get_option_value
    local nvim_buf_line_count = vim.api.nvim_buf_line_count
    local nvim_buf_get_offset = vim.api.nvim_buf_get_offset
    local ts_stop = vim.treesitter.stop
    local ts_get_lang = vim.treesitter.language.get_lang
    local ts_active = vim.treesitter.highlighter.active
    local ts_start = vim.treesitter.start

    local parser_cache = setmetatable({}, {
      __index = function(t, lang)
        local ok = pcall(vim.treesitter.language.inspect, lang)
        t[lang] = ok
        return ok
      end,
    })

    local SIZE_LIMIT = 1024 * 1024
    local LINE_LIMIT = 20000

    local function should_disable(buf)
      if not nvim_buf_is_valid(buf) then
        return true
      end
      if nvim_get_option_value("buftype", { buf = buf }) ~= "" then
        return true
      end
      local line_count = nvim_buf_line_count(buf)
      return line_count > LINE_LIMIT or nvim_buf_get_offset(buf, line_count) > SIZE_LIMIT
    end

    local function highlight_buffer(buf)
      if should_disable(buf) then
        pcall(ts_stop, buf)
        return
      end

      local ft = nvim_get_option_value("filetype", { buf = buf })
      if not ft or ft == "" then
        return
      end

      for sub_ft in ft:gmatch("[^.]+") do
        local lang = ts_get_lang(sub_ft) or sub_ft
        if lang and parser_cache[lang] then
          local active = ts_active[buf]
          if active and active.tree and active.tree:lang() == lang then
            break
          end
          pcall(ts_start, buf, lang)
          break
        end
      end
    end

    local ts_group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = ts_group,
      pattern = "*",
      callback = function(args)
        highlight_buffer(args.buf)
      end,
    })

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        highlight_buffer(buf)
      end
    end

    vim.schedule(function()
      local installed = ts.get_installed()
      local installed_set = {}
      for _, p in ipairs(installed) do
        installed_set[p] = true
      end

      local missing = vim.tbl_filter(function(p)
        return not installed_set[p]
      end, parsers)

      if #missing > 0 then
        vim.notify("[Treesitter] Installing missing parsers: " .. table.concat(missing, ", "), vim.log.levels.INFO)
        ts.install(missing):await(function(err)
          if err then
            vim.notify("[Treesitter] Installation failed: " .. tostring(err), vim.log.levels.ERROR)
            return
          end
          for _, p in ipairs(missing) do
            parser_cache[p] = nil
          end
          vim.notify("[Treesitter] All parsers installed successfully!", vim.log.levels.INFO)
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              pcall(vim.api.nvim_exec_autocmds, "FileType", { buffer = buf })
            end
          end
        end)
      end
    end)
  end,
}
