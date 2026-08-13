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
}
