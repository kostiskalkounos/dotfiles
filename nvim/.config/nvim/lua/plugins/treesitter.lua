return {
  "nvim-treesitter/nvim-treesitter",
  event = "UIEnter",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    local nvim_buf_get_offset = vim.api.nvim_buf_get_offset
    local nvim_buf_is_loaded = vim.api.nvim_buf_is_loaded
    local nvim_buf_is_valid = vim.api.nvim_buf_is_valid
    local nvim_buf_line_count = vim.api.nvim_buf_line_count
    local nvim_create_augroup = vim.api.nvim_create_augroup
    local nvim_create_autocmd = vim.api.nvim_create_autocmd
    local nvim_get_option_value = vim.api.nvim_get_option_value
    local nvim_list_bufs = vim.api.nvim_list_bufs
    local ts_get_lang = vim.treesitter.language.get_lang
    local ts_inspect = vim.treesitter.language.inspect
    local ts_start = vim.treesitter.start
    local ts_stop = vim.treesitter.stop
    local vim_schedule = vim.schedule

    local SIZE_LIMIT = 2 * 1024 * 1024
    local LINE_LIMIT = 50000

    for ft, lang in pairs({
      gitconfig = "git_config",
      gitrebase = "git_rebase",
      javascriptreact = "tsx",
      jsonc = "json",
      sh = "bash",
      typescriptreact = "tsx",
    }) do
      pcall(vim.treesitter.language.register, lang, ft)
    end

    local parser_cache = setmetatable({}, {
      __index = function(t, lang)
        local ok = pcall(ts_inspect, lang)
        t[lang] = ok
        return ok
      end,
    })

    local ft_lang_cache = {}
    local function get_ft_lang(ft)
      if ft_lang_cache[ft] ~= nil then
        return ft_lang_cache[ft]
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

    local function should_enable(buf)
      if not nvim_buf_is_valid(buf) or not nvim_buf_is_loaded(buf) then
        return false
      end
      if nvim_get_option_value("buftype", { buf = buf }) ~= "" then
        return false
      end
      local line_count = nvim_buf_line_count(buf)
      if line_count > LINE_LIMIT or nvim_buf_get_offset(buf, line_count) > SIZE_LIMIT then
        return false
      end
      return true
    end

    local function try_start_highlight(buf)
      if not should_enable(buf) then
        pcall(ts_stop, buf)
        return
      end
      local ft = nvim_get_option_value("filetype", { buf = buf })
      if not ft or ft == "" then
        pcall(ts_stop, buf)
        return
      end
      local lang = get_ft_lang(ft)
      if lang then
        pcall(ts_start, buf, lang)
      else
        pcall(ts_stop, buf)
      end
    end

    nvim_create_autocmd("FileType", {
      group = nvim_create_augroup("TreesitterHighlight", { clear = true }),
      callback = function(args)
        try_start_highlight(args.buf)
      end,
    })

    for _, buf in ipairs(nvim_list_bufs()) do
      try_start_highlight(buf)
    end

    vim.defer_fn(function()
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
        "query",
        "rust",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "zsh",
      }

      local installed_list = ts.get_installed()
      local installed = {}
      for _, p in ipairs(installed_list) do
        installed[p] = true
      end

      local to_install = {}
      for _, p in ipairs(parsers) do
        if not installed[p] then
          table.insert(to_install, p)
        end
      end

      if #to_install > 0 then
        ts.install(to_install):await(function(err)
          vim_schedule(function()
            if err then
              vim.notify("Treesitter: Some parsers failed to install.", vim.log.levels.WARN)
            end
            parser_cache = setmetatable({}, getmetatable(parser_cache))
            ft_lang_cache = {}
            for _, buf in ipairs(nvim_list_bufs()) do
              try_start_highlight(buf)
            end
          end)
        end)
      end
    end, 1000)
  end,
}
