return { -- Autoformat
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = {
			timeout_ms = 2500,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			lua = { "stylua" },
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
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			-- javascript = { { "prettierd", "prettier" } },
		},
	},
}
