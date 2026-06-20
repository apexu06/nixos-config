vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
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
})
