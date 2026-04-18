return {
	"MeanderingProgrammer/render-markdown.nvim",
	event = "BufReadPost *.md",
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		completions = { lsp = { enabled = true } },
	},
}
