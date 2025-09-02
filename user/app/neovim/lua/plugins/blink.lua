return {
	event = "VeryLazy",
	"saghen/blink.cmp",
	dependencies = "rafamadriz/friendly-snippets",
	version = "*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	---
	opts = {
		keymap = {
			preset = "default",
			["<Tab>"] = {
				function(cmp)
					cmp.accept()
				end,
			},
			["<C-k>"] = {
				function(cmp)
					cmp.show_documentation()
				end,
			},
		},

		fuzzy = {
			implementation = "rust",
		},
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		completion = {
			ghost_text = {
				enabled = true,
			},
			menu = {
				auto_show = true,
				winblend = 0,
				scrollbar = false,
				border = "none",
				draw = {
					padding = 2,
					columns = { { "kind_icon" }, { "label", "label_description" } },
				},
			},
			documentation = {
				auto_show_delay_ms = 0,
			},
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "lazydev" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
