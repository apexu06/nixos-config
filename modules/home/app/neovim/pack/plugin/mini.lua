vim.schedule(function()
	vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

	require("mini.ai").setup({ n_lines = 500 })
	require("mini.comment").setup()
	require("mini.pairs").setup()
	require("mini.surround").setup()
	require("mini.git").setup()
	require("mini.icons").setup()
	require("mini.statusline").setup()

	local hipatterns = require("mini.hipatterns")
	hipatterns.setup({
		highlighters = {
			hex_color = hipatterns.gen_highlighter.hex_color(),
		},
	})
end)
