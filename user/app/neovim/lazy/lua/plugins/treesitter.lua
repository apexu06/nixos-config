-- return {
-- 	"romus204/tree-sitter-manager.nvim",
-- 	event = "VeryLazy",
-- 	dependencies = {}, -- tree-sitter CLI must be installed system-wide
-- 	config = function()
-- 		require("tree-sitter-manager").setup({
-- 			-- Optional: custom paths
-- 			-- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
-- 			-- query_dir = vim.fn.stdpath("data") .. "/site/queries",
-- 		})
--
-- 		local parsers = {
-- 			"bash",
-- 			"c",
-- 			"html",
-- 			"lua",
-- 			"markdown",
-- 			"svelte",
-- 			"typescript",
-- 			"javascript",
-- 			"nix",
-- 			"json",
-- 			"rust",
-- 			"cpp",
-- 			"go",
-- 			"gitcommit",
-- 			"gitignore",
-- 			"kdl",
-- 			"yaml",
-- 			"qmljs",
-- 			"c_sharp",
-- 			"typst",
-- 			"vim",
-- 			"bash",
-- 			"fish",
-- 			"make",
-- 			"cmake",
-- 			"toml",
-- 		}
--
-- 		local patterns = {}
-- 		for _, parser in ipairs(parsers) do
-- 			local parser_patterns = vim.treesitter.language.get_filetypes(parser)
-- 			for _, pp in pairs(parser_patterns) do
-- 				table.insert(patterns, pp)
-- 			end
-- 		end
--
-- 		vim.api.nvim_create_autocmd("FileType", {
-- 			pattern = parsers,
-- 			callback = function()
-- 				vim.treesitter.start()
-- 			end,
-- 		})
-- 	end,
-- }

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
