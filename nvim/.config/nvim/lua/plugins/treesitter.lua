return {
  "nvim-treesitter/nvim-treesitter",
  event = "UIEnter",
  build = ":TSUpdate",
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

    local nvim_buf_get_offset = vim.api.nvim_buf_get_offset
    local nvim_buf_is_loaded = vim.api.nvim_buf_is_loaded
    local nvim_buf_is_valid = vim.api.nvim_buf_is_valid
    local nvim_buf_line_count = vim.api.nvim_buf_line_count
    local nvim_create_augroup = vim.api.nvim_create_augroup
    local nvim_create_autocmd = vim.api.nvim_create_autocmd
    local nvim_get_option_value = vim.api.nvim_get_option_value
    local nvim_list_bufs = vim.api.nvim_list_bufs
    local ts_active = vim.treesitter.highlighter.active
    local ts_get_lang = vim.treesitter.language.get_lang
    local ts_start = vim.treesitter.start
    local ts_stop = vim.treesitter.stop

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

    local parser_cache = setmetatable({}, {
      __index = function(t, lang)
        local ok = pcall(vim.treesitter.language.inspect, lang)
        t[lang] = ok
        return ok
      end,
    })

    local ft_lang_cache = {}

    local function get_ft_lang(ft)
      local cached = ft_lang_cache[ft]
      if cached ~= nil then
        return cached
      end

      for sub_ft in ft:gmatch("[^.]+") do
        local lang = ts_get_lang(sub_ft) or sub_ft
        if lang and parser_cache[lang] then
          ft_lang_cache[ft] = lang
          return lang
        end
      end
      ft_lang_cache[ft] = false
      return false
    end

    local function highlight_buffer(buf)
      local ft = nvim_get_option_value("filetype", { buf = buf })
      if not ft or ft == "" then
        return
      end

      local lang = get_ft_lang(ft)
      if not lang then
        return
      end

      if should_disable(buf) then
        pcall(ts_stop, buf)
        return
      end

      local active = ts_active[buf]
      if not (active and active.tree and active.tree:lang() == lang) then
        pcall(ts_start, buf, lang)
      end
    end

    local ts_group = nvim_create_augroup("TreesitterHighlight", { clear = true })
    nvim_create_autocmd("FileType", {
      group = ts_group,
      pattern = "*",
      callback = function(args)
        highlight_buffer(args.buf)
      end,
    })

    for _, buf in ipairs(nvim_list_bufs()) do
      if nvim_buf_is_loaded(buf) then
        highlight_buffer(buf)
      end
    end

    vim.defer_fn(function()
      local missing = {}
      for _, p in ipairs(parsers) do
        if not parser_cache[p] then
          table.insert(missing, p)
        end
      end

      if #missing > 0 then
        ts.install(missing):await(function(err)
          vim.schedule(function()
            if err then
              return
            end
            for _, p in ipairs(missing) do
              parser_cache[p] = true
            end
            ft_lang_cache = {}
            for _, buf in ipairs(nvim_list_bufs()) do
              if nvim_buf_is_loaded(buf) then
                highlight_buffer(buf)
              end
            end
          end)
        end)
      end
    end, 1000)
  end,
}
