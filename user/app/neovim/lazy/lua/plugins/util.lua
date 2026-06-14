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
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		event = "BufReadPost *.md",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
		},
	},
}
