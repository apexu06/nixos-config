return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		indent = { enabled = true, animate = { enabled = false } },
		input = { enabled = true },
		notifier = { enabled = true },
		picker = { enabled = true, layout = {
			layout = {
				backdrop = false,
			},
		} },
		quickfile = { enabled = true },
		terminal = { enabled = false, win = { position = "float" } },
		rename = { enabled = true },
		lazygit = { enabled = true },
		scope = { enabled = true },
	},
}
