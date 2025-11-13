vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.hlsearch = true
vim.opt.breakindent = true
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.pumheight = 10
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
local map = vim.keymap.set

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/folke/snacks.nvim", load = false },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-sleuth" },
})

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	ensure_installed = { "bash", "c", "html", "lua", "markdown", "svelte", "typescript", "javascript" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

require("mini.ai").setup({ n_lines = 500 })
local statusline = require("mini.statusline")
statusline.setup()
statusline.section_location = function()
	return "%2l:%-2v"
end
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.git").setup()
require("mini.icons").setup()

require("oil").setup()
require("snacks").setup({
	bigfile = { enabled = true },
	bufdelete = { enabled = true },
	indent = { enabled = true, animate = { enabled = false } },
	input = { enabled = true },
	notifier = { enabled = true },
	picker = { enabled = true, layout = {
		layout = {
			backdrop = false,
		},
	} },
	quickfile = { enabled = true },
	terminal = { enabled = false, win = { position = "float" } },
	rename = { enabled = true },
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

---keybinds
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>s", ":update<CR> :source<CR>")
map("n", "<leader>o", "<CMD>Oil<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
map("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
map("n", "Ne", vim.diagnostic.goto_prev)
map("n", "ne", vim.diagnostic.goto_next)
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

vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

--- Colorscheme
local transparent = true
require("tokyonight").setup({
	style = "night",
	transparent = transparent,
	styles = {
		sidebars = transparent and "transparent" or "dark",
		floats = transparent and "transparent" or "dark",
	},
})
vim.cmd("colorscheme tokyonight-night")

--- formatting
require("conform").setup({
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
	},
})

--- lsp
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")
vim.lsp.enable({ "lua_ls", "rust_analyer", "gopls", "clangd", "ts_ls", "py_lsp", "astro", "tailwindcss", "svelte" })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = {
					"${3rd}/luv/library",
					unpack(vim.api.nvim_get_runtime_file("", true)),
				},
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})
