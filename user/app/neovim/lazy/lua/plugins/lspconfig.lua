return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	config = function()
		vim.lsp.enable({
			"lua_ls",
			"rust_analyer",
			"gopls",
			"ts_ls",
			"py_lsp",
			"astro",
			"tailwindcss",
			"svelte",
			"nil_ls",
			"qmlls",
			"clangd",
			"tinymist",
		})

		vim.lsp.config("ccls", {
			cmd = { "ccls", '--init={"clang": {"extraArgs": ["-std=c++23", "-Wall", "-Wextra", "-Iinclude"]}}' },
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
	end,
}
