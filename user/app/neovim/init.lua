require("config.lazy")
require("config.options")

-- keymaps
vim.keymap.set("n", "Ne", vim.diagnostic.goto_prev)
vim.keymap.set("n", "ne", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.keymap.set("n", "L", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "H", ":bprev<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>v", function()
	vim.cmd("vsplit")
	vim.cmd("wincmd l")
	Snacks.picker.files()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>h", function()
	vim.cmd("split")
	vim.cmd("wincmd j")
	Snacks.picker.files()
end, { noremap = true, silent = true })

-- stuff
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	signs = true,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.md", "*.tex" },
	callback = function()
		vim.cmd("setlocal textwidth=80")
		vim.cmd("setlocal colorcolumn=80")
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesActionRename",
	callback = function(event)
		Snacks.rename.on_rename_file(event.data.from, event.data.to)
	end,
})
