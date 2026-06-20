vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/saghen/blink.cmp", version = "v1.7.0" },
		})
		require("blink.cmp").setup({
			keymap = {
				preset = "default",
				["<Tab>"] = {
					function(cmp)
						cmp.accept()
					end,
				},
				["K"] = {
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
		})
	end,
})
