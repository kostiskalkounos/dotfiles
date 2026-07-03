local api = vim.api
local fn = vim.fn
local uv = vim.uv
local json = vim.json
local o = vim.o
local env = vim.env
local string_byte = string.byte

local nvim_create_augroup = api.nvim_create_augroup
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_create_user_command = api.nvim_create_user_command
local nvim_set_option_value = api.nvim_set_option_value
local nvim_command = api.nvim_command
local schedule = vim.schedule

nvim_create_autocmd("TextYankPost", {
  group = nvim_create_augroup("highlight_yank", { clear = true }),
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

local g = nvim_create_augroup("CursorLineControl", { clear = true })
nvim_create_autocmd("WinLeave", {
  group = g,
  callback = function()
    nvim_set_option_value("cursorline", false, { win = 0 })
  end,
})

nvim_create_autocmd("WinEnter", {
  group = g,
  callback = function()
    nvim_set_option_value("cursorline", true, { win = 0 })
  end,
})

nvim_create_user_command("Term", function(opt)
  nvim_command("split")
  nvim_command("resize 15")
  nvim_command("terminal " .. opt.args)
end, { nargs = "*", complete = "file" })

nvim_create_user_command("Vterm", function(opt)
  nvim_command("vsplit")
  nvim_command("terminal " .. opt.args)
end, { nargs = "*", complete = "file" })

local rpc_socket_path = nil

local function setup_rpc_socket()
  local pid = uv.os_getpid()
  local socket_dir = _G.stdpaths.cache .. "/sockets"
  fn.mkdir(socket_dir, "p")

  rpc_socket_path = socket_dir .. "/nvim-" .. pid .. ".sock"
  if uv.fs_stat(rpc_socket_path) then
    pcall(os.remove, rpc_socket_path)
  end
  pcall(fn.serverstart, rpc_socket_path)

  schedule(function()
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

local rpc_group = nvim_create_augroup("PredictableRpcSocket", { clear = true })
nvim_create_autocmd("VimEnter", {
  group = rpc_group,
  desc = "Start RPC server on predictable socket for theme hot-reloads",
  callback = setup_rpc_socket,
})

nvim_create_autocmd("VimLeavePre", {
  group = rpc_group,
  desc = "Stop RPC server and clean up socket on exit",
  callback = function()
    if rpc_socket_path and uv.fs_stat(rpc_socket_path) then
      pcall(fn.serverstop, rpc_socket_path)
      pcall(os.remove, rpc_socket_path)
    end
  end,
})

local cached_vars = nil

local function load_vars_from_zsh(force_reload)
  if cached_vars and not force_reload then
    return cached_vars
  end

  local home = os.getenv("HOME") or ""
  local zshrc_path = home .. "/.zshrc"
  local cache_dir = _G.stdpaths.cache
  local cache_path = cache_dir .. "/fzf_bat_themes.json"

  if not force_reload then
    local f = io.open(cache_path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local success, data = pcall(json.decode, content)
      if success and data then
        cached_vars = data

        uv.fs_stat(zshrc_path, function(err, zshrc_stat)
          if not err and zshrc_stat then
            uv.fs_stat(cache_path, function(err2, cache_stat)
              if not err2 and cache_stat then
                if zshrc_stat.mtime.sec > cache_stat.mtime.sec then
                  schedule(function()
                    load_vars_from_zsh(true)
                    update_fzf_opts(true)
                  end)
                end
              end
            end)
          end
        end)

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
      local b1 = string_byte(line, 1)
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

  fn.mkdir(cache_dir, "p")
  local fc = io.open(cache_path, "w")
  if fc then
    fc:write(json.encode(cached_vars))
    fc:close()
  end

  return cached_vars
end

local function update_fzf_opts(force)
  local is_forced = (force == true)
  if not is_forced and o.background == env.FZF_THEME then
    return
  end

  schedule(function()
    if not is_forced and o.background == env.FZF_THEME then
      return
    end
    local vars = load_vars_from_zsh()
    if o.background == "dark" then
      env.FZF_DEFAULT_OPTS = vars.dark.fzf ~= "" and vars.dark.fzf or nil
      env.FZF_THEME = "dark"
      env.BAT_THEME = vars.dark.bat
    else
      env.FZF_DEFAULT_OPTS = vars.light.fzf ~= "" and vars.light.fzf or nil
      env.FZF_THEME = "light"
      env.BAT_THEME = vars.light.bat
    end
  end)
end

local fzf_theme_group = nvim_create_augroup("FzfThemeUpdate", { clear = true })
nvim_create_autocmd("OptionSet", {
  group = fzf_theme_group,
  pattern = "background",
  callback = update_fzf_opts,
})

_G.update_fzf_opts = update_fzf_opts

local ft_group = nvim_create_augroup("FastFileTypes", { clear = true })
nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = "cpp",
  callback = function(args)
    vim.keymap.set("n", "<leader><Tab>", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = args.buf, silent = true })
  end,
})

nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = "go",
  callback = function(args)
    nvim_set_option_value("expandtab", false, { buf = args.buf })
  end,
})
