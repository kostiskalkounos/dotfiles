local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font_with_fallback({
	"Monaco",
})
config.font_size = 13
config.window_decorations = "RESIZE"

return config
