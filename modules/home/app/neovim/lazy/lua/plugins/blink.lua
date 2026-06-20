return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<Tab>"] = {
				function(cmp)
					cmp.accept()
				end,
			},
			["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
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
	},
	opts_extend = { "sources.default" },
}
