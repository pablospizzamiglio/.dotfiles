-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- config.use_fancy_tab_bar = true
-- config.front_end = "OpenGL"

config.color_scheme = "Catppuccin Macchiato"
-- config.font = wezterm.font("Fira Code Nerd Font Mono")
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 15.0
-- config.line_height = 1.4
config.line_height = 1.2

-- config.window_padding = {
-- 	left = "1cell",
-- 	right = "1cell",
-- 	top = "0.5cell",
-- 	bottom = "0.5cell",
-- }

-- config.window_decorations = "TITLE | RESIZE | INTEGRATED_BUTTONS"
-- config.integrated_title_button_style = "Gnome"

-- and finally, return the configuration to wezterm
return config
