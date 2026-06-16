local api = vim.api

local api_nvim_command = api.nvim_command
local api_nvim_create_augroup = api.nvim_create_augroup
local api_nvim_create_autocmd = api.nvim_create_autocmd
local api_nvim_create_user_command = api.nvim_create_user_command

api_nvim_create_autocmd("TextYankPost", {
  group = api_nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150, on_macro = false })
  end,
})

vim.filetype.add({
  pattern = {
    ["Jenkinsfile.*"] = "groovy",
    ["Dockerfile.*"] = "dockerfile",
  },
})

local g = api_nvim_create_augroup("CursorLineControl", { clear = true })
api_nvim_create_autocmd("WinLeave", {
  group = g,
  callback = function()
    vim.wo[0].cursorline = false
  end,
})

api_nvim_create_autocmd("WinEnter", {
  group = g,
  callback = function()
    vim.wo[0].cursorline = true
  end,
})

api_nvim_create_user_command("Term", function(o)
  api_nvim_command("split")
  api_nvim_command("resize 15")
  api_nvim_command("terminal " .. o.args)
end, { nargs = "*", complete = "file" })

api_nvim_create_user_command("Vterm", function(o)
  api_nvim_command("vsplit")
  api_nvim_command("terminal " .. o.args)
end, { nargs = "*", complete = "file" })

local rpc_socket_path = nil

local function setup_rpc_socket()
  local uv = vim.uv or vim.loop
  local pid = uv.os_getpid()
  local socket_dir = (os.getenv("HOME") or "") .. "/.cache/nvim/sockets"
  vim.fn.mkdir(socket_dir, "p")

  rpc_socket_path = socket_dir .. "/nvim-" .. pid .. ".sock"
  if uv.fs_stat(rpc_socket_path) then
    pcall(os.remove, rpc_socket_path)
  end
  pcall(vim.fn.serverstart, rpc_socket_path)

  vim.schedule(function()
    local req = uv.fs_scandir(socket_dir)
    if req then
      while true do
        local name, _ = uv.fs_scandir_next(req)
        if not name then
          break
        end
        local socket_pid = name:match("nvim%-(%d+)%.sock$")
        if socket_pid then
          socket_pid = tonumber(socket_pid)
          if socket_pid then
            local success, _, err_name = uv.kill(socket_pid, 0)
            local is_running = (success == 0 or err_name == "EPERM")
            if not is_running then
              pcall(os.remove, socket_dir .. "/" .. name)
            end
          end
        end
      end
    end
  end)
end

local rpc_group = api_nvim_create_augroup("PredictableRpcSocket", { clear = true })

api_nvim_create_autocmd("VimEnter", {
  group = rpc_group,
  desc = "Start RPC server on predictable socket for theme hot-reloads",
  callback = setup_rpc_socket,
})

api_nvim_create_autocmd("VimLeave", {
  group = rpc_group,
  desc = "Stop RPC server and clean up socket on exit",
  callback = function()
    if rpc_socket_path and (vim.uv or vim.loop).fs_stat(rpc_socket_path) then
      pcall(vim.fn.serverstop, rpc_socket_path)
      pcall(os.remove, rpc_socket_path)
    end
  end,
})

local cached_vars = nil

local function load_vars_from_zsh()
  if cached_vars then
    return cached_vars
  end

  local home = os.getenv("HOME") or ""
  local zshrc_path = home .. "/.zshrc"
  local cache_dir = home .. "/.cache/nvim"
  local cache_path = cache_dir .. "/fzf_bat_themes.json"

  local uv = vim.uv or vim.loop
  local zshrc_stat = uv.fs_stat(zshrc_path)
  local cache_stat = uv.fs_stat(cache_path)

  local zshrc_mtime = zshrc_stat and zshrc_stat.mtime.sec or 0
  local cache_mtime = cache_stat and cache_stat.mtime.sec or 0

  if cache_mtime >= zshrc_mtime and cache_mtime > 0 then
    local f = io.open(cache_path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local success, data = pcall(vim.json.decode, content)
      if success and data then
        cached_vars = data
        return cached_vars
      end
    end
  end

  local fzf_common = ""
  local dark_opts = ""
  local light_opts = ""
  local dark_bat = "Catppuccin Macchiato"
  local light_bat = "Catppuccin Latte"

  local f = io.open(zshrc_path, "r")
  if f then
    local in_dark_func = false
    local in_light_func = false
    local found_common = false
    local found_dark_opts = false
    local found_light_opts = false
    local found_dark_bat = false
    local found_light_bat = false

    for line in f:lines() do
      local b1 = line:byte(1)
      if b1 == 70 then
        local common = line:match('^FZF_COMMON_OPTS=[\x27"](.*)[\x27"]')
        if common then
          fzf_common = common
          found_common = true
        end
      elseif b1 == 68 then
        local dark = line:match('^DARK_FZF_OPTS=[\x27"](.*)[\x27"]')
        if dark then
          dark_opts = dark
          found_dark_opts = true
        end
      elseif b1 == 76 then
        local light = line:match('^LIGHT_FZF_OPTS=[\x27"](.*)[\x27"]')
        if light then
          light_opts = light
          found_light_opts = true
        end
      elseif b1 == 95 then
        if line:match("^_set_dark_theme%s*%(%s*%)") then
          in_dark_func = true
        elseif line:match("^_set_light_theme%s*%(%s*%)") then
          in_light_func = true
        end
      elseif b1 == 125 then
        in_dark_func = false
        in_light_func = false
      elseif in_dark_func or in_light_func then
        local bat = line:match('BAT_THEME=[\x27"](.*)[\x27"]')
        if bat then
          if in_dark_func then
            dark_bat = bat
            found_dark_bat = true
          else
            light_bat = bat
            found_light_bat = true
          end
        end
      end

      if found_common and found_dark_opts and found_light_opts and found_dark_bat and found_light_bat then
        break
      end
    end
    f:close()
  end

  if dark_opts ~= "" and fzf_common ~= "" then
    dark_opts = dark_opts:gsub("%$%{FZF_COMMON_OPTS%}", fzf_common)
  end
  if light_opts ~= "" and fzf_common ~= "" then
    light_opts = light_opts:gsub("%$%{FZF_COMMON_OPTS%}", fzf_common)
  end

  cached_vars = {
    dark = { fzf = dark_opts, bat = dark_bat },
    light = { fzf = light_opts, bat = light_bat },
  }

  vim.fn.mkdir(cache_dir, "p")
  local fc = io.open(cache_path, "w")
  if fc then
    fc:write(vim.json.encode(cached_vars))
    fc:close()
  end

  return cached_vars
end

local function update_fzf_opts()
  if vim.o.background == vim.env.FZF_THEME then
    return
  end

  vim.schedule(function()
    if vim.o.background == vim.env.FZF_THEME then
      return
    end
    local vars = load_vars_from_zsh()
    if vim.o.background == "dark" then
      vim.env.FZF_DEFAULT_OPTS = vars.dark.fzf ~= "" and vars.dark.fzf or nil
      vim.env.FZF_THEME = "dark"
      vim.env.BAT_THEME = vars.dark.bat
    else
      vim.env.FZF_DEFAULT_OPTS = vars.light.fzf ~= "" and vars.light.fzf or nil
      vim.env.FZF_THEME = "light"
      vim.env.BAT_THEME = vars.light.bat
    end
  end)
end

local fzf_theme_group = api_nvim_create_augroup("FzfThemeUpdate", { clear = true })
api_nvim_create_autocmd("OptionSet", {
  group = fzf_theme_group,
  pattern = "background",
  callback = update_fzf_opts,
})

_G.update_fzf_opts = update_fzf_opts

local get_option = vim.filetype.get_option
local has_ts_cs, ts_cs
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
  if option == "commentstring" then
    if has_ts_cs == nil then
      has_ts_cs, ts_cs = pcall(require, "ts_context_commentstring")
      if not has_ts_cs then
        pcall(require("lazy").load, { plugins = { "nvim-ts-context-commentstring" } })
        has_ts_cs, ts_cs = pcall(require, "ts_context_commentstring")
      end
    end
    if has_ts_cs and ts_cs and ts_cs.calculate_commentstring then
      return ts_cs.calculate_commentstring() or get_option(filetype, option)
    end
  end
  return get_option(filetype, option)
end

local lualine_new_file_group = api_nvim_create_augroup("LualineNewFileCheck", { clear = true })
api_nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = lualine_new_file_group,
  callback = function(args)
    vim.b[args.buf].lualine_is_new_file = false
  end,
})

api_nvim_create_autocmd("BufNewFile", {
  group = lualine_new_file_group,
  callback = function(args)
    vim.b[args.buf].lualine_is_new_file = true
  end,
})
