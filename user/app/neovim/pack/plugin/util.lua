vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	"https://github.com/j-hui/fidget.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-sleuth",
})

require("fidget").setup({
	progress = {
		suppress_on_insert = true,
		display = {
			render_limit = 6,
			done_ttl = 1,
		},
	},
	notification = {
		window = {
			winblend = 0,
		},
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "bash", "c", "html", "lua", "markdown", "svelte", "typescript", "javascript" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})
