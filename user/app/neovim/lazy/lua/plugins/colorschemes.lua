local status, active_theme = pcall(require, "../theme_choice")
if not status then
	active_theme = "tokyonight"
end

return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		enabled = active_theme == "tokyonight",
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
		"f4z3r/gruvbox-material.nvim",
		name = "gruvbox-material",
		priority = 1000,
		enabled = active_theme == "gruvbox-material",
		config = function()
			require("gruvbox-material").setup({
				contrast = "hard",
				background = { transparent = true },
			})
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		enabled = active_theme == "catppuccin-latte",
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
			})
			vim.cmd.colorscheme("catppuccin-latte")
		end,
	},
	{
		"Aejkatappaja/sora",
		priority = 1000,
		opts = {},
		enabled = active_theme == "sora",
		config = function(_, opts)
			require("sora").setup(opts)
			vim.cmd("colorscheme sora")
		end,
	},
}
