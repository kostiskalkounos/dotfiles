local api = vim.api
local b = vim.b
local g = vim.g
local o = vim.o

local redrawstatus = function()
  api.nvim_command("redrawstatus")
end

local count_diag = vim.diagnostic.count
local get_option_value = api.nvim_get_option_value
local nvim_buf_get_name = api.nvim_buf_get_name
local nvim_buf_is_valid = api.nvim_buf_is_valid
local nvim_get_current_win = api.nvim_get_current_win
local nvim_win_get_buf = api.nvim_win_get_buf

local EMPTY = ""
local SPACE = " "
local TAB = "          "
local SEPARATOR = "%="

local FILENAME = "%f%<"
local FLAGS = "%( %m%r%)"
local LOCATION = "%10l:%-9c"
local PROGRESS = "%3p%% "

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

local function rebuild_format_strings(c)
  if c.is_special then
    return
  end

  local left = "%-35(" .. c.git .. TAB .. c.diag .. "%)"
  local right = "%35(" .. c.branch .. LOCATION .. PROGRESS .. "%)"

  c.active = HL_ACTIVE .. left .. SEPARATOR .. FILENAME .. c.icon_active .. FLAGS .. SEPARATOR .. right
  c.inactive = HL_INACTIVE .. SEPARATOR .. FILENAME .. c.icon_inactive .. FLAGS .. SEPARATOR
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
  }
  rebuild_format_strings(c)
  return c
end

local EMPTY_CACHE = create_empty_cache()
local cache = {}
local win_to_buf = {}

local bg_active_cache = nil
local bg_inactive_cache = nil
local generated_icon_hls = {}
local mini_icons_module = nil
local current_win_cache = nvim_get_current_win()

local function ensure_cache(bufnr)
  local c = cache[bufnr]
  if not c then
    c = create_empty_cache()
    cache[bufnr] = c
  end
  return c
end

local function refresh_hl_cache()
  local sl = api.nvim_get_hl(0, { name = "StatusLine", link = false })
  local slnc = api.nvim_get_hl(0, { name = "StatusLineNC", link = false })
  bg_active_cache = sl.bg
  bg_inactive_cache = slnc.bg
  generated_icon_hls = {}
end

local function update_icon_cache(bufnr)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  local c = ensure_cache(bufnr)

  if not mini_icons_module then
    mini_icons_module = package.loaded["mini.icons"]
    if not mini_icons_module then
      c.icon_active, c.icon_inactive = EMPTY, EMPTY
      rebuild_format_strings(c)
      return
    end
  end

  local bufname = nvim_buf_get_name(bufnr)
  local filename = bufname:match("[^/\\]+$") or bufname
  local icon, hl_group = mini_icons_module.get("file", filename)

  if icon and hl_group then
    local active_hl_name = "StlIconActive_" .. hl_group
    local inactive_hl_name = "StlIconInactive_" .. hl_group

    if not generated_icon_hls[hl_group] then
      local icon_colors = api.nvim_get_hl(0, { name = hl_group, link = false })
      api.nvim_set_hl(0, active_hl_name, { fg = icon_colors.fg, bg = bg_active_cache })
      api.nvim_set_hl(0, inactive_hl_name, { fg = icon_colors.fg, bg = bg_inactive_cache })
      generated_icon_hls[hl_group] = true
    end

    c.icon_active = SPACE .. "%#" .. active_hl_name .. "#" .. icon .. HL_ACTIVE
    c.icon_inactive = SPACE .. "%#" .. inactive_hl_name .. "#" .. icon .. HL_INACTIVE
  else
    c.icon_active, c.icon_inactive = EMPTY, EMPTY
  end
  rebuild_format_strings(c)
end

local function update_diag_cache(bufnr)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  local counts = count_diag(bufnr)
  if not counts then
    return
  end

  local err = counts[SEV_ERROR] or 0
  local warn = counts[SEV_WARN] or 0
  local info = counts[SEV_INFO] or 0
  local hint = counts[SEV_HINT] or 0

  local s = EMPTY
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

  local c = ensure_cache(bufnr)
  c.diag = s ~= EMPTY and s:sub(1, -2) or EMPTY
  rebuild_format_strings(c)
end

local function update_git_cache(bufnr)
  if not nvim_buf_is_valid(bufnr) then
    return
  end

  local buf_vars = b[bufnr]
  if not buf_vars then
    return
  end
  local dict = buf_vars.gitsigns_status_dict
  local head = buf_vars.gitsigns_head

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

  local c = ensure_cache(bufnr)
  c.git = s ~= EMPTY and (SPACE .. s:sub(1, -2)) or EMPTY
  c.branch = (head and head ~= EMPTY) and (BRANCH_ICON .. head) or EMPTY
  rebuild_format_strings(c)
end

local function update_buftype_cache(bufnr)
  if not nvim_buf_is_valid(bufnr) then
    return
  end
  local c = ensure_cache(bufnr)
  local bt = get_option_value("buftype", { buf = bufnr })

  if bt == "terminal" or bt == "nofile" or bt == "prompt" then
    c.is_special = true
    local ft = get_option_value("filetype", { buf = bufnr })
    c.special_string = HL_INACTIVE .. SPACE .. (ft ~= EMPTY and ft or bt) .. SEPARATOR
  else
    c.is_special = false
  end
  rebuild_format_strings(c)
end

local augroup = api.nvim_create_augroup("NativeStatuslineOptimized", { clear = true })

api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "WinNew" }, {
  group = augroup,
  callback = function(args)
    current_win_cache = nvim_get_current_win()
    win_to_buf[current_win_cache] = args.buf
  end,
})

api.nvim_create_autocmd("WinClosed", {
  group = augroup,
  callback = function(args)
    win_to_buf[tonumber(args.match)] = nil
  end,
})

api.nvim_create_autocmd({ "BufEnter", "BufFilePost", "FileType" }, {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    update_buftype_cache(buf)
    update_icon_cache(buf)
    update_git_cache(buf)
    update_diag_cache(buf)
  end,
})

api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "VeryLazy",
  callback = function()
    for bufnr in pairs(cache) do
      update_icon_cache(bufnr)
    end
    redrawstatus()
  end,
})

api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  callback = function(args)
    update_git_cache(args.buf)
  end,
})

api.nvim_create_autocmd("DiagnosticChanged", {
  group = augroup,
  callback = function(args)
    update_diag_cache(args.buf)
    redrawstatus()
  end,
})

api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "GitSignsUpdate",
  callback = function(args)
    update_git_cache((args.data and args.data.buffer) or args.buf or api.nvim_get_current_buf())
    redrawstatus()
  end,
})

api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    refresh_hl_cache()
    for bufnr in pairs(cache) do
      update_icon_cache(bufnr)
    end
    redrawstatus()
  end,
})

api.nvim_create_autocmd("BufWipeout", {
  group = augroup,
  callback = function(args)
    cache[args.buf] = nil
  end,
})

_G.OptimizedStatusline = function()
  local winid = g.statusline_winid
  local c = cache[win_to_buf[winid] or nvim_win_get_buf(winid)] or EMPTY_CACHE

  if c.is_special then
    return c.special_string
  end
  if winid == current_win_cache then
    return c.active
  end

  return c.inactive
end

refresh_hl_cache()
o.statusline = "%!v:lua.OptimizedStatusline()"
