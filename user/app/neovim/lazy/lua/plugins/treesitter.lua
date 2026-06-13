return {
	"arborist-ts/arborist.nvim",
	event = "VeryLazy",
	config = function()
		require("arborist").setup({
			update_cadence = "weekly",
			prefer_wasm = false,
			install_popular = false,
			ensure_installed = {
				"lua",
				"c",
				"cpp",
				"rust",
				"json",
				"fish",
				"nix",
				"yaml",
				"bash",
			},
		})
	end,
}
