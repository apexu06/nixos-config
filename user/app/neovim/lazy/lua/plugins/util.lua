return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = true,
		event = "VeryLazy",
	},
	{
		event = "BufReadPost *.*",
		"lewis6991/gitsigns.nvim",
	},
	{
		"j-hui/fidget.nvim",
		event = "BufReadPost *.*",
		opts = {
			-- options
		},
	},
}
