return {

	{
		"nvim-mini/mini.comment",
		event = "BufReadPost *.*",
		version = "*",
		config = function()
			require("mini.comment").setup()
		end,
	},

	{
		"nvim-mini/mini.ai",
		event = "BufReadPost *.*",
		version = "*",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
		end,
	},

	{
		"nvim-mini/mini.pairs",
		event = "InsertEnter",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},

	{
		"nvim-mini/mini.surround",
		event = "BufReadPost *.*",
		version = "*",
		config = function()
			require("mini.surround").setup()
		end,
	},

	{
		"nvim-mini/mini.icons",
		event = "BufRead",
		version = "*",
		config = function()
			require("mini.icons").setup()
		end,
	},

	{
		"nvim-mini/mini.statusline",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("mini.statusline").setup()
		end,
	},

	{
		"nvim-mini/mini.hipatterns",
		event = "BufReadPost *.*",
		version = "*",
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},

	-- "nvim-mini/mini.nvim",
	-- event = "VeryLazy",
	-- version = "*",
	-- config = function()
	-- 	require("mini.ai").setup({ n_lines = 500 })
	-- 	require("mini.comment").setup()
	-- 	require("mini.pairs").setup()
	-- 	require("mini.surround").setup()
	-- 	require("mini.git").setup()
	-- 	require("mini.icons").setup()
	-- 	require("mini.statusline").setup()
	--
	-- 	local hipatterns = require("mini.hipatterns")
	-- 	hipatterns.setup({
	-- 		highlighters = {
	-- 			hex_color = hipatterns.gen_highlighter.hex_color(),
	-- 		},
	-- 	})
	-- end,
}
