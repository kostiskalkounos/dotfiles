local api = vim.api
local fn = vim.fn
local b = vim.b
local g = vim.g
local o = vim.o
local diagnostic = vim.diagnostic

local nvim_get_current_win = api.nvim_get_current_win
local nvim_win_get_buf = api.nvim_win_get_buf
local nvim_buf_is_valid = api.nvim_buf_is_valid
local nvim_buf_get_name = api.nvim_buf_get_name
local nvim_get_hl = api.nvim_get_hl
local nvim_set_hl = api.nvim_set_hl
local nvim_get_option_value = api.nvim_get_option_value
local nvim_command = api.nvim_command
local nvim_create_augroup = api.nvim_create_augroup
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_get_current_buf = api.nvim_get_current_buf
local win_gettype = fn.win_gettype
local fnamemodify = fn.fnamemodify

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
  local c = {
    git = EMPTY,
    branch = EMPTY,
    diag = EMPTY,
    icon_active = EMPTY,
    icon_inactive = EMPTY,
    is_special = false,
    special_string = EMPTY,
    active = EMPTY,
    inactive = EMPTY,
    initialized = false,
  }
  rebuild_active_string(c)
  rebuild_inactive_string(c)
  return c
end

local cache = {}
local current_win_cache = nvim_get_current_win()

local bg_active_cache = nil
local generated_icon_hls = {}
local mini_icons_module = nil

local function redrawstatus()
  nvim_command("redrawstatus")
end

local function is_float(winid)
  return win_gettype(winid or 0) == "popup"
end

local function ensure_cache(bufnr)
  local c = cache[bufnr]
  if not c then
    c = create_empty_cache()
    cache[bufnr] = c
  end
  return c
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
  c = c or ensure_cache(bufnr)
  if c.is_special then
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

local function update_diag_cache(bufnr, c, defer_rebuild)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  c = c or ensure_cache(bufnr)
  if c.is_special then
    return
  end

  local s = EMPTY
  if package.loaded["vim.diagnostic"] then
    local counts = diagnostic.count(bufnr)
    if counts then
      local err = counts[SEV_ERROR] or 0
      local warn = counts[SEV_WARN] or 0
      local info = counts[SEV_INFO] or 0
      local hint = counts[SEV_HINT] or 0

      if err > 0 then
        s = s .. SIGN_ERROR .. err .. SPACE
      end
      if warn > 0 then
        s = s .. SIGN_WARN .. warn .. SPACE
      end
      if info > 0 then
        s = s .. SIGN_INFO .. info .. SPACE
      end
      if hint > 0 then
        s = s .. SIGN_HINT .. hint .. SPACE
      end
    end
  end

  c.diag = s ~= EMPTY and s:sub(1, -2) or EMPTY
  if not defer_rebuild then
    rebuild_active_string(c)
  end
end

local function update_git_cache(bufnr, c, defer_rebuild)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  c = c or ensure_cache(bufnr)
  if c.is_special then
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
      s = s .. HL_ADD .. "+" .. added .. HL_ACTIVE .. SPACE
    end
    if changed > 0 then
      s = s .. HL_WARN .. "~" .. changed .. HL_ACTIVE .. SPACE
    end
    if removed > 0 then
      s = s .. HL_ERROR .. "-" .. removed .. HL_ACTIVE .. SPACE
    end
  end

  c.git = s ~= EMPTY and (SPACE .. s:sub(1, -2)) or EMPTY
  c.branch = (head and head ~= EMPTY) and (BRANCH_ICON .. head) or EMPTY
  if not defer_rebuild then
    rebuild_active_string(c)
  end
end

local function update_buftype_cache(bufnr, c, defer_rebuild)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  c = c or ensure_cache(bufnr)
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

local augroup = nvim_create_augroup("NativeStatuslineOptimized", { clear = true })
nvim_create_autocmd({ "BufWinEnter", "FocusGained", "TabEnter", "WinEnter" }, {
  group = augroup,
  callback = function()
    local winid = nvim_get_current_win()
    if not is_float(winid) then
      current_win_cache = winid
      redrawstatus()
    end
  end,
})

nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    local c = ensure_cache(buf)
    if not c.initialized then
      initialize_cache(buf, c)
    end
  end,
})

nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    local c = ensure_cache(buf)
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
    local c = ensure_cache(buf)
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
    update_diag_cache(args.buf)
    redrawstatus()
  end,
})

local is_global_stl = o.laststatus == 3
nvim_create_autocmd("OptionSet", {
  group = augroup,
  pattern = "laststatus",
  callback = function()
    is_global_stl = o.laststatus == 3
    redrawstatus()
  end,
})

nvim_create_autocmd("User", {
  group = augroup,
  pattern = "GitSignsUpdate",
  callback = function(args)
    update_git_cache((args.data and args.data.buffer) or args.buf or nvim_get_current_buf())
    redrawstatus()
  end,
})

nvim_create_autocmd("User", {
  group = augroup,
  pattern = "VeryLazy",
  callback = function()
    for bufnr, c in pairs(cache) do
      update_icon_cache(bufnr, c)
    end
    redrawstatus()
  end,
})

_G.OptimizedStatusline = function()
  local winid = g.statusline_winid
  if not winid or winid == 0 then
    winid = nvim_get_current_win()
  end
  local bufnr = nvim_win_get_buf(winid)
  local c = cache[bufnr]

  if not c or not c.initialized then
    c = ensure_cache(bufnr)
    initialize_cache(bufnr, c)
  end

  if is_global_stl or winid == current_win_cache then
    return c.active
  end

  return c.inactive
end

refresh_hl_cache()
o.statusline = "%!v:lua.OptimizedStatusline()"
