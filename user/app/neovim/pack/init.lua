---@diagnostic disable: deprecated
vim.opt.number = true
vim.opt.undofile = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.hlsearch = true
vim.opt.breakindent = true
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.pumheight = 10
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.inccommand = "split"
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.md", "*.tex", "*.typ" },
	callback = function()
		vim.cmd("setlocal textwidth=100")
		vim.cmd("setlocal colorcolumn=100")
	end,
})

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	signs = true,
})

vim.filetype.add({
	extension = {
		svx = "svelte",
	},
})

local map = vim.keymap.set

map("n", "<leader>w", ":write<CR>")
map("n", "<leader>s", ":update<CR> :source<CR>")
map("n", "<leader>o", "<CMD>Oil<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
map("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
map("n", "nE", vim.diagnostic.goto_prev)
map("n", "<leader>q", ":copen<CR>")
map("n", "ne", vim.diagnostic.goto_next)
map("n", "<leader>mr", ":make run<CR>")
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "<leader>q", vim.diagnostic.setloclist)
map("n", "L", ":bnext<CR>", { noremap = true, silent = true })
map("n", "H", ":bprev<CR>", { noremap = true, silent = true })
map("n", "<leader>sf", function()
	Snacks.picker.files()
end)
vim.keymap.set("n", "<leader>sg", function()
	Snacks.picker.grep()
end)
vim.keymap.set("n", "<leader>sb", function()
	Snacks.picker.buffers()
end)
vim.keymap.set("n", "<leader>gd", function()
	Snacks.picker.lsp_definitions()
end)
vim.keymap.set("n", "<leader>gD", function()
	Snacks.picker.lsp_declarations()
end)
vim.keymap.set("n", "<leader>gI", function()
	Snacks.picker.lsp_implementations()
end)
vim.keymap.set("n", "<leader>gy", function()
	Snacks.picker.lsp_type_definitions()
end)
vim.keymap.set("n", "<leader>b", function()
	Snacks.bufdelete()
end)
vim.keymap.set("n", "<leader>B", function()
	vim.api.nvim_win_close(0, false)
end)
