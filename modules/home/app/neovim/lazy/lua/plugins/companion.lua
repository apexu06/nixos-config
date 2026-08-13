return {
	"olimorris/codecompanion.nvim",
	event = "BufReadPost *.*",
	version = "^19.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	enabled = vim.fn.hostname() == "nixp",
	opts = {
		display = {
			chat = {
				fold_reasoning = false,
				show_reasoning = false,
			},
		},
		interactions = {
			chat = {
				adapter = {
					name = "ollama",
					model = "gemma4:12b",
				},
				opts = {
					---@param ctx CodeCompanion.SystemPrompt.Context
					---@return string
					system_prompt = function(ctx)
						return ctx.default_system_prompt
							.. [[Additional context: All code blocks must end with four ` (````)]]
					end,
				},
			},
			inline = {
				adapter = {
					name = "ollama",
					model = "qwen2.5-coder:14b",
				},
			},
		},
	},
}
