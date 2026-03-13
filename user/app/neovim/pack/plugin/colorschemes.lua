vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/f4z3r/gruvbox-material.nvim",
})


--- Colorscheme
local transparent = true
require("tokyonight").setup({
	style = "night",
	transparent = transparent,
	styles = {
		sidebars = transparent and "transparent" or "dark",
		floats = transparent and "transparent" or "dark",
	},
})

require("gruvbox-material").setup({
	contrast = "hard", 
  background = {
    transparent = true,
  }
})

function setColorscheme()
	local file_path = vim.fn.stdpath("config") .. "/colorscheme.txt"
	local f = assert(io.open(file_path, "rb"))
	local content = f:read("*all")
	f:close()

	vim.cmd.colorscheme(vim.trim(content))
end

setColorscheme()
