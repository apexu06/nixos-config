vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	notify_on_error = false,
	format_on_save = {
		timeout_ms = 2500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		astro = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		javascript = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },
		sh = { "shfmt" },
		markdown = { "prettierd" },
		python = { "ruff" },
		html = { "prettierd" },
		nix = { "alejandra" },
	},
})
