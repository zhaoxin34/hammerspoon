PaperWM = hs.loadSpoon("PaperWM")

-- Add 40px offset for an external status bar
PaperWM.external_bar = { top = 20, bottom = 0 }
PaperWM.window_gap = { top = 10, bottom = 10, left = 10, right = 10 }

PaperWM:bindHotkeys({
	-- switch to a new focused window in tiled grid
	focus_left = { { "alt", "ctrl" }, "h" },
	focus_right = { { "alt", "ctrl" }, "l" },
	focus_up = { { "alt", "ctrl" }, "k" },
	focus_down = { { "alt", "ctrl" }, "j" },

	-- switch windows by cycling forward/backward
	-- (forward = down or right, backward = up or left)
	focus_prev = { { "alt", "ctrl" }, "p" },
	focus_next = { { "alt", "ctrl" }, "n" },

	-- move windows around in tiled grid
	swap_left = { { "alt", "ctrl" }, "i" },
	swap_right = { { "alt", "ctrl" }, "o" },
	swap_up = { { "alt", "ctrl" }, "up" },
	swap_down = { { "alt", "ctrl" }, "down" },

	-- position and resize focused window
	center_window = { { "alt", "cmd" }, "c" },
	full_width = { { "alt", "cmd" }, "f" },
	cycle_width = { { "alt", "cmd" }, "r" },
	reverse_cycle_width = { { "ctrl", "alt", "cmd" }, "r" },
	cycle_height = { { "alt", "cmd", "shift" }, "r" },
	reverse_cycle_height = { { "ctrl", "alt", "cmd", "shift" }, "r" },

	-- increase/decrease width
	increase_width = { { "alt", "ctrl" }, "u" },
	decrease_width = { { "alt", "ctrl" }, "y" },

	-- move focused window into / out of a column
	slurp_in = { { "alt", "cmd" }, "i" },
	barf_out = { { "alt", "cmd" }, "o" },

	-- move the focused window into / out of the tiling layer
	toggle_floating = { { "alt", "cmd", "shift" }, "escape" },
	-- raise all floating windows on top of tiled windows
	focus_floating = { { "alt", "cmd", "shift" }, "f" },

	-- focus the first / second / etc window in the current space
	focus_window_1 = { { "cmd", "shift" }, "1" },
	focus_window_2 = { { "cmd", "shift" }, "2" },
	focus_window_3 = { { "cmd", "shift" }, "3" },
	focus_window_4 = { { "cmd", "shift" }, "4" },
	focus_window_5 = { { "cmd", "shift" }, "5" },
	focus_window_6 = { { "cmd", "shift" }, "6" },
	focus_window_7 = { { "cmd", "shift" }, "7" },
	focus_window_8 = { { "cmd", "shift" }, "8" },
	focus_window_9 = { { "cmd", "shift" }, "9" },

	-- switch to a new Mission Control space
	switch_space_l = { { "alt", "cmd" }, "," },
	switch_space_r = { { "alt", "cmd" }, "." },
	switch_space_1 = { { "alt", "cmd" }, "1" },
	switch_space_2 = { { "alt", "cmd" }, "2" },
	switch_space_3 = { { "alt", "cmd" }, "3" },
	switch_space_4 = { { "alt", "cmd" }, "4" },
	switch_space_5 = { { "alt", "cmd" }, "5" },
	switch_space_6 = { { "alt", "cmd" }, "6" },
	switch_space_7 = { { "alt", "cmd" }, "7" },
	switch_space_8 = { { "alt", "cmd" }, "8" },
	switch_space_9 = { { "alt", "cmd" }, "9" },
})

PaperWM.window_ratios = { 3 / 4, 3 / 4, 3 / 4 }
-- number of fingers to detect a horizontal swipe, set to 0 to disable (the default)
PaperWM.swipe_fingers = 3
-- increase this number to make windows move farther when swiping
PaperWM.swipe_gain = 1.0

PaperWM.window_filter:rejectApp("iStat Menus Status")
PaperWM.window_filter:rejectApp("Finder")
PaperWM.window_filter:rejectApp("WeChat")
PaperWM.window_filter:rejectApp("DingTalk")

PaperWM:start()
