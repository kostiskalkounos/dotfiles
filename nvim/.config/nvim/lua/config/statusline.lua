local api = vim.api
local fn = vim.fn
local b = vim.b
local g = vim.g
local o = vim.o

local nvim_buf_get_name = api.nvim_buf_get_name
local nvim_buf_is_valid = api.nvim_buf_is_valid
local nvim_command = api.nvim_command
local nvim_create_augroup = api.nvim_create_augroup
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_get_current_buf = api.nvim_get_current_buf
local nvim_get_current_win = api.nvim_get_current_win
local nvim_get_hl = api.nvim_get_hl
local nvim_get_option_value = api.nvim_get_option_value
local nvim_set_hl = api.nvim_set_hl
local nvim_win_get_buf = api.nvim_win_get_buf
local nvim_win_is_valid = api.nvim_win_is_valid
local win_gettype = fn.win_gettype

local EMPTY = ""
local SPACE = " "
local TAB = "          "
local SEPARATOR = "%="

local FILENAME = "%f%<"
local FLAGS = "%( %m%r%)"
local LOCATION = "%10l:%-9c"
local PROGRESS = "%3p%%"

local HL_ACTIVE = "%#StatusLine#"
local HL_INACTIVE = "%#StatusLineNC#"
local HL_BRANCH = "%#StlBranchIcon#"
local BRANCH_ICON = TAB .. HL_BRANCH .. " " .. HL_ACTIVE

local HL_ADD = "%#GitSignsAdd#"
local HL_ERROR = "%#DiagnosticError#"
local HL_WARN = "%#DiagnosticWarn#"
local HL_INFO = "%#DiagnosticInfo#"
local HL_HINT = "%#DiagnosticHint#"

local SIGN_ERROR = HL_ERROR .. "  " .. HL_ACTIVE
local SIGN_WARN = HL_WARN .. "  " .. HL_ACTIVE
local SIGN_INFO = HL_INFO .. "  " .. HL_ACTIVE
local SIGN_HINT = HL_HINT .. "󰌶 " .. HL_ACTIVE

local SEV_ERROR = 1
local SEV_WARN = 2
local SEV_INFO = 3
local SEV_HINT = 4

local ACTIVE_FIRST = HL_ACTIVE .. SPACE .. FILENAME
local ACTIVE_SECOND = SPACE .. FLAGS .. SPACE
local ACTIVE_THIRD = LOCATION .. PROGRESS .. SPACE

local INACTIVE_FIRST = HL_INACTIVE .. SPACE .. FILENAME
local INACTIVE_SECOND = SPACE .. FLAGS

local function rebuild_active_string(c)
  if c.is_special then
    return
  end
  c.active = ACTIVE_FIRST .. c.icon_active .. ACTIVE_SECOND .. c.git .. SEPARATOR .. c.diag .. c.branch .. ACTIVE_THIRD
end

local function rebuild_inactive_string(c)
  if c.is_special then
    return
  end
  c.inactive = INACTIVE_FIRST .. c.icon_inactive .. INACTIVE_SECOND
end

local function create_empty_cache()
  return {
    git = EMPTY,
    branch = EMPTY,
    diag = EMPTY,
    icon_active = EMPTY,
    icon_inactive = EMPTY,
    is_special = false,
    active = EMPTY,
    inactive = EMPTY,
    initialized = false,
  }
end

local cache = {}
local dirty_buffers = {}
local current_win_cache = nvim_get_current_win()
local global_statusline, local_statusline

local bg_active_cache = nil
local generated_icon_hls = {}
local is_insert_mode = false
local mini_icons_module = nil
local is_global_stl = o.laststatus == 3

local function redrawstatus()
  nvim_command("redrawstatus")
end

local function is_float(winid)
  return win_gettype(winid or 0) == "popup"
end

local function refresh_hl_cache()
  local sl = nvim_get_hl(0, { name = "StatusLine", link = false })
  bg_active_cache = sl.bg
  generated_icon_hls = {}
end

local function update_icon_cache(bufnr, c, defer_rebuild, force)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  c = c or cache[bufnr]
  if not c or c.is_special then
    return
  end

  local bufname = nvim_buf_get_name(bufnr)
  if not force and c.bufname == bufname then
    return
  end
  c.bufname = bufname

  if bufname == EMPTY then
    c.icon_active, c.icon_inactive = EMPTY, EMPTY
    if not defer_rebuild then
      rebuild_active_string(c)
      rebuild_inactive_string(c)
    end
    return
  end

  if not mini_icons_module then
    mini_icons_module = package.loaded["mini.icons"]
    if not mini_icons_module then
      c.icon_active, c.icon_inactive = EMPTY, EMPTY
      if not defer_rebuild then
        rebuild_active_string(c)
        rebuild_inactive_string(c)
      end
      return
    end
  end

  local icon, hl_group = mini_icons_module.get("file", bufname)
  if icon and hl_group then
    local active_hl_name = "StlIconActive_" .. hl_group

    if not generated_icon_hls[hl_group] or force then
      local icon_colors = nvim_get_hl(0, { name = hl_group, link = false })
      nvim_set_hl(0, active_hl_name, { fg = icon_colors.fg, bg = bg_active_cache })
      generated_icon_hls[hl_group] = true
    end

    c.icon_active = SPACE .. "%#" .. active_hl_name .. "#" .. icon .. HL_ACTIVE
    c.icon_inactive = SPACE .. icon
  else
    c.icon_active, c.icon_inactive = EMPTY, EMPTY
  end
  if not defer_rebuild then
    rebuild_active_string(c)
    rebuild_inactive_string(c)
  end
end

local diag_mod = nil
local function update_diag_cache(bufnr, c, defer_rebuild)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  c = c or cache[bufnr]
  if not c or c.is_special then
    return
  end

  local s = EMPTY
  if not diag_mod then
    diag_mod = package.loaded["vim.diagnostic"]
  end
  if diag_mod then
    local counts = diag_mod.count(bufnr)
    if counts then
      local err = counts[SEV_ERROR] or 0
      local warn = counts[SEV_WARN] or 0
      local info = counts[SEV_INFO] or 0
      local hint = counts[SEV_HINT] or 0

      if err > 0 then
        s = SIGN_ERROR .. err
      end
      if warn > 0 then
        s = (s == EMPTY and EMPTY or s .. SPACE) .. SIGN_WARN .. warn
      end
      if info > 0 then
        s = (s == EMPTY and EMPTY or s .. SPACE) .. SIGN_INFO .. info
      end
      if hint > 0 then
        s = (s == EMPTY and EMPTY or s .. SPACE) .. SIGN_HINT .. hint
      end
    end
  end

  c.diag = s
  if not defer_rebuild then
    rebuild_active_string(c)
  end
end

local function update_git_cache(bufnr, c, defer_rebuild)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  c = c or cache[bufnr]
  if not c or c.is_special then
    return
  end

  local buf_vars = b[bufnr]
  local dict = buf_vars and buf_vars.gitsigns_status_dict
  local head = buf_vars and buf_vars.gitsigns_head

  local s = EMPTY
  if dict and type(dict) == "table" then
    local added = dict.added or 0
    local changed = dict.changed or 0
    local removed = dict.removed or 0

    if added > 0 then
      s = HL_ADD .. "+" .. added .. HL_ACTIVE
    end
    if changed > 0 then
      s = (s == EMPTY and EMPTY or s .. SPACE) .. HL_WARN .. "~" .. changed .. HL_ACTIVE
    end
    if removed > 0 then
      s = (s == EMPTY and EMPTY or s .. SPACE) .. HL_ERROR .. "-" .. removed .. HL_ACTIVE
    end
  end

  c.git = s ~= EMPTY and (SPACE .. s) or EMPTY
  c.branch = (head and head ~= EMPTY) and (BRANCH_ICON .. head) or EMPTY
  if not defer_rebuild then
    rebuild_active_string(c)
  end
end

local function update_buftype_cache(bufnr, c, defer_rebuild)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  c = c or cache[bufnr]
  if not c then
    return
  end
  local bt = nvim_get_option_value("buftype", { buf = bufnr })

  if bt == "terminal" or bt == "nofile" or bt == "prompt" or bt == "help" or bt == "quickfix" then
    c.is_special = true
    local ft = nvim_get_option_value("filetype", { buf = bufnr })
    local name = ft ~= EMPTY and ft or bt

    c.active = HL_ACTIVE .. SPACE .. name .. SEPARATOR
    c.inactive = HL_INACTIVE .. SPACE .. name .. SEPARATOR
  else
    c.is_special = false
    if not defer_rebuild then
      rebuild_active_string(c)
      rebuild_inactive_string(c)
    end
  end
end

local function initialize_cache(bufnr, c)
  update_buftype_cache(bufnr, c, true)
  if not c.is_special then
    update_icon_cache(bufnr, c, true)
    update_git_cache(bufnr, c, true)
    update_diag_cache(bufnr, c, true)
    rebuild_active_string(c)
    rebuild_inactive_string(c)
  end
  c.initialized = true
end

local function get_or_create_cache(bufnr)
  local c = cache[bufnr]
  if not c then
    c = create_empty_cache()
    cache[bufnr] = c
  end
  if not c.initialized then
    initialize_cache(bufnr, c)
  end
  return c
end

local augroup = nvim_create_augroup("NativeStatuslineOptimized", { clear = true })
nvim_create_autocmd({ "BufWinEnter", "FocusGained", "TabEnter", "WinEnter" }, {
  group = augroup,
  callback = function()
    local winid = nvim_get_current_win()
    if not is_float(winid) then
      current_win_cache = winid
    elseif not nvim_win_is_valid(current_win_cache) then
      current_win_cache = winid
    end
  end,
})

nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup,
  callback = function(args)
    get_or_create_cache(args.buf)
  end,
})

nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    local c = get_or_create_cache(buf)
    update_buftype_cache(buf, c)
    redrawstatus()
  end,
})

nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    local c = cache[buf]
    if not c then
      return
    end
    update_buftype_cache(buf, c, true)
    if not c.is_special then
      update_icon_cache(buf, c, true)
      rebuild_active_string(c)
      rebuild_inactive_string(c)
    end
  end,
})

nvim_create_autocmd("BufFilePost", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    local c = cache[buf]
    if not c then
      return
    end
    if not c.is_special then
      update_icon_cache(buf, c, true)
      rebuild_active_string(c)
      rebuild_inactive_string(c)
    end
  end,
})

nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = augroup,
  callback = function(args)
    cache[args.buf] = nil
    dirty_buffers[args.buf] = nil
  end,
})

nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    refresh_hl_cache()
    for bufnr, c in pairs(cache) do
      update_icon_cache(bufnr, c, false, true)
    end
    redrawstatus()
  end,
})

nvim_create_autocmd("DiagnosticChanged", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    local c = cache[buf]
    if not c then
      return
    end
    if is_insert_mode then
      c.diag_dirty = true
      dirty_buffers[buf] = true
    else
      update_diag_cache(buf, c)
      redrawstatus()
    end
  end,
})

nvim_create_autocmd("InsertEnter", {
  group = augroup,
  callback = function()
    is_insert_mode = true
  end,
})

nvim_create_autocmd("InsertLeave", {
  group = augroup,
  callback = function()
    is_insert_mode = false
    local redrawn = false
    for buf in pairs(dirty_buffers) do
      local c = cache[buf]
      if c then
        update_diag_cache(buf, c)
        c.diag_dirty = false
      end
      dirty_buffers[buf] = nil
      redrawn = true
    end
    if redrawn then
      redrawstatus()
    end
  end,
})

nvim_create_autocmd("OptionSet", {
  group = augroup,
  pattern = "laststatus",
  callback = function()
    is_global_stl = o.laststatus == 3
    _G.OptimizedStatusline = is_global_stl and global_statusline or local_statusline
    redrawstatus()
  end,
})

nvim_create_autocmd("User", {
  group = augroup,
  pattern = "GitSignsUpdate",
  callback = function(args)
    local bufnr = (args.data and args.data.buffer) or args.buf or nvim_get_current_buf()
    local c = cache[bufnr]
    if not c then
      return
    end
    update_git_cache(bufnr, c)
    redrawstatus()
  end,
})

nvim_create_autocmd("User", {
  group = augroup,
  pattern = "VeryLazy",
  callback = function()
    for bufnr, c in pairs(cache) do
      update_icon_cache(bufnr, c, false, true)
    end
    redrawstatus()
  end,
})

global_statusline = function()
  local bufnr = nvim_get_current_buf()
  local c = cache[bufnr]
  if c and c.initialized then
    return c.active
  end
  return get_or_create_cache(bufnr).active
end

local_statusline = function()
  local winid = g.statusline_winid
  if not winid or winid == 0 then
    winid = current_win_cache
    if not nvim_win_is_valid(winid) then
      winid = nvim_get_current_win()
      current_win_cache = winid
    end
  end

  if winid == current_win_cache then
    local bufnr = nvim_get_current_buf()
    local c = cache[bufnr]
    if c and c.initialized then
      return c.active
    end
    return get_or_create_cache(bufnr).active
  end

  local bufnr = nvim_win_get_buf(winid)
  local c = cache[bufnr]
  if c and c.initialized then
    return c.inactive
  end
  return get_or_create_cache(bufnr).inactive
end

_G.OptimizedStatusline = is_global_stl and global_statusline or local_statusline

refresh_hl_cache()
o.statusline = "%!v:lua.OptimizedStatusline()"
