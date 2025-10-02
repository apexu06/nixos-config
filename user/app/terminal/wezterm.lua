---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action
---@type Config
local config = wezterm.config_builder()

config.font = wezterm.font("IosevkaTerm Nerd Font", { weight = "Medium", stretch = "ExtraCondensed" })
config.font_size = 13.5
config.cell_width = 1
config.freetype_load_target = "HorizontalLcd"
config.dpi = 384.0

config.colors = {
	-- background = "#16161E",
	cursor_bg = "#ffffff",
}

config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.tab_and_split_indices_are_zero_based = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.scrollback_lines = 20000
config.window_close_confirmation = "NeverPrompt"

if wezterm.target_triple:find("windows") then
	config.wsl_domains = {
		{ name = "WSL:Arch", distribution = "Arch" },
	}
	config.default_domain = "WSL:Arch"
	config.window_background_opacity = 1
	config.win32_system_backdrop = "Disable"
	config.allow_win32_input_mode = false
	config.max_fps = 180
end

local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	{ key = "h", mods = "LEADER", action = act.SplitHorizontal },
	{ key = "v", mods = "LEADER", action = act.SplitVertical },
	{ key = "Enter", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "ALT", action = act.MoveTabRelative(-1) },
	{ key = "]", mods = "ALT", action = act.MoveTabRelative(1) },
	{ key = "p", mods = "ALT", action = act.ShowTabNavigator },
	{ key = "e", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
}

for i = 0, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i),
	})
end

return config
