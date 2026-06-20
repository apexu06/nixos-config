vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"gopls",
	"ts_ls",
	"ty",
	"astro",
	"bash-language-server",
	"tailwindcss",
	"svelte",
	"nil_ls",
	"qmlls",
	"clangd",
	"tinymist",
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = {
					"${3rd}/luv/library",
					unpack(vim.api.nvim_get_runtime_file("", true)),
				},
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})
