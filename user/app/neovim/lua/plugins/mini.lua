return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup({ n_lines = 500 })

		-- local statusline = require("mini.statusline")
		-- statusline.setup()
		-- statusline.section_location = function()
		-- 	return "%2l:%-2v"
		-- end

		-- require("mini.tabline").setup({
		-- 	vim.cmd("hi MiniTablineFill guibg=#00000000"),
		-- })

		require("mini.comment").setup()
		require("mini.pairs").setup()
		require("mini.surround").setup()
		require("mini.git").setup()
		require("mini.files").setup({
			vim.keymap.set("n", "<leader>o", ":lua MiniFiles.open()<CR>", { noremap = true, silent = true }),
			mappings = {
				go_in = "n",
				go_out = "c",
				go_out_plus = "C",
				go_in_plus = "<CR>",
			},
		})

		require("mini.icons").setup()
	end,
}
