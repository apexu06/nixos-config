return {
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {
			progress = {
				suppress_on_insert = true,
				display = {
					render_limit = 6,
					done_ttl = 1,
				},
			},
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		branch = "master",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "bash", "c", "html", "lua", "markdown", "svelte", "typescript", "javascript" },
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"mrjones2014/smart-splits.nvim",
		lazy = true,
		event = "VeryLazy",
	},
	{
		event = "VeryLazy",
		"lewis6991/gitsigns.nvim",
	},
	{
		event = "VeryLazy",
		"tpope/vim-sleuth",
	},
}
