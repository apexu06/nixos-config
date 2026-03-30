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
		lazy = false,
		config = function()
			local parsers = {
				"bash",
				"c",
				"html",
				"lua",
				"markdown",
				"svelte",
				"typescript",
				"javascript",
				"nix",
				"json",
				"rust",
				"cpp",
				"go",
				"gitcommit",
				"gitignore",
				"kdl",
				"yaml",
				"qmljs",
				"c_sharp",
				"typst",
				"vim",
				"bash",
				"fish",
				"make",
				"cmake",
			}
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = parsers,
				callback = function()
					vim.treesitter.start()
				end,
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
