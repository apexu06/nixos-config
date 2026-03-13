return {
	{
		"j-hui/fidget.nvim",
		event = "BufReadPost *.*",
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
		build = ":TSUpdate",
		branch = "master",
		event = "BufReadPost *.*",
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
		event = "BufReadPost *.*",
		"lewis6991/gitsigns.nvim",
	},
	{
		event = "InsertEnter",
		"tpope/vim-sleuth",
	},
}
