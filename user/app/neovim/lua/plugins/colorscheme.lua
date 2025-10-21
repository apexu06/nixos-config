return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			local transparent = true

			require("tokyonight").setup({
				style = "night",
				transparent = transparent,
				styles = {
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
				},
			})

			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		"rjshkhr/shadow.nvim",
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function() end,
	},
	{
		"Skardyy/makurai-nvim",
		priority = 1000,
		config = function()
			-- vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#565A60" })
		end,
	},
}
