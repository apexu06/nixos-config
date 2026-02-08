return { -- Autoformat
	"stevearc/conform.nvim",
  event = "VeryLazy",
	opts = {
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
			svelte = { "prettierd" },
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
	},
}
