return {
	enabled = false,
	"stevearc/oil.nvim",
	--@module 'oil'
	--@type oil.SetupOpts
	opts = {
		watch_for_changes = true,
		columns = {
			"icon",
			"size",
		},
		view_options = {
			show_hidden = true,
		},
		keymaps = {
			["<C-c>"] = { "actions.parent", mode = "n" },
			["q"] = { "actions.close", mode = "n" },
			["<C-l>"] = false,
			["<C-h>"] = false,
		},
	},
}
