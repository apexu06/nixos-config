local active_theme = vim.env.NVIM_THEME or "tokyonight"

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
		config = function(_, _)
			require("sora").setup({
				transparent = false,
				italic_comments = true,

				-- Q
				on_highlights = function(hl, colors)
					hl.SnacksPickerDir = { fg = colors.fg_comment }
					hl.SnacksPickerBorder = { bg = colors.bg, fg = colors.border }
					hl.NormalFloat = { bg = colors.bg }
				end,
			})

			vim.cmd("colorscheme sora")
		end,
	},
}
