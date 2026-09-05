return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = true,
		event = "VeryLazy",
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost *.*",
	},
	{
		"j-hui/fidget.nvim",
		event = "BufReadPost *.*",
		config = function()
			require("fidget").setup({})
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		event = "BufReadPost *.*",
		opts = {
			preview = {
				filetypes = { "markdown", "codecompanion" },
				ignore_buftypes = {},
			},
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		-- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
		-- additional lazy config to defer loading is not really needed...
		config = function()
			-- optional setup call to override plugin options
			-- alternatively you can set options with vim.g.grug_far = { ... }
			require("grug-far").setup({
				-- options, see Configuration section below
				-- there are no required options atm
			})
		end,
	},
}
