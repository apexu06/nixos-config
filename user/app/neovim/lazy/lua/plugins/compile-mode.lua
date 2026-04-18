return {
	"ej-shafran/compile-mode.nvim",
	version = "^5.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	config = function()
		---@type CompileModeOpts
		vim.g.compile_mode = {
			input_word_completion = true,
			default_command = {
				python = "python %",
				javascript = "bun %",
				typescript = "bun %",
				c = "make run",
				cpp = "make run",
				go = "go run %",
				rust = "cargo run",
			},
			recompile_no_fail = true,
			ask_to_interrupt = false,
			auto_jump_to_first_error = true,

			-- to add ANSI escape code support, add:
			-- baleia_setup = true,

			-- to make `:Compile` replace special characters (e.g. `%`) in
			-- the command (and behave more like `:!`), add:
			-- bang_expansion = true,
		}
	end,
}
