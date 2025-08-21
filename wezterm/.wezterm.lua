-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 16
config.color_scheme = "Catppuccin Mocha"

-- Change the background
config.window_background_opacity = 0.7
config.kde_window_background_blur = true

config.enable_tab_bar = false
config.window_decorations = "NONE"

config.window_padding = {
	left = 20,
	right = 20,
	top = 16,
	bottom = 8,
}

-- Open URL in the browser when Ctrl + right click
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- Finally, return the configuration to wezterm:
return config
