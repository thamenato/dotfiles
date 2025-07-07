local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- background transparency
config.window_background_opacity = 0.85

-- cyberdream theme for wezterm
config.colors = {
	foreground = "#ffffff",
	background = "#16181a",

	cursor_bg = "#ffffff",
	cursor_fg = "#16181a",
	cursor_border = "#ffffff",

	selection_fg = "#ffffff",
	selection_bg = "#3c4048",

	scrollbar_thumb = "#16181a",
	split = "#16181a",

	ansi = { "#16181a", "#ff6e5e", "#5eff6c", "#f1ff5e", "#5ea1ff", "#bd5eff", "#5ef1ff", "#ffffff" },
	brights = { "#3c4048", "#ff6e5e", "#5eff6c", "#f1ff5e", "#5ea1ff", "#bd5eff", "#5ef1ff", "#ffffff" },
	indexed = { [16] = "#ffbd5e", [17] = "#ff6e5e" },
}

-- font settings
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10

-- window padding
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

return config
