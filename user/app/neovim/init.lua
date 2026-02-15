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
	pattern = { "*.md", "*.tex" },
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

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/f4z3r/gruvbox-material.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/folke/snacks.nvim", load = false },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-sleuth" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.7.0" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/MagicDuck/grug-far.nvim" },
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = true,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "lsp_status" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
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

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	ensure_installed = { "bash", "c", "html", "lua", "markdown", "svelte", "typescript", "javascript" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

require("mini.ai").setup({ n_lines = 500 })
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.git").setup()
require("mini.icons").setup()

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

require("oil").setup({
	columns = {
		"icon",
		"size",
	},
	view_options = {
		show_hidden = true,
	},
	keymaps = {
		["<C-c>"] = { "actions.parent", mode = "n" },
		["q"] = { "actions.close", mode = "n" },
	},
})

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

map("n", "<A-h>", require("smart-splits").resize_left)
map("n", "<A-j>", require("smart-splits").resize_down)
map("n", "<A-k>", require("smart-splits").resize_up)
map("n", "<A-l>", require("smart-splits").resize_right)
map("n", "<C-h>", require("smart-splits").move_cursor_left)
map("n", "<C-j>", require("smart-splits").move_cursor_down)
map("n", "<C-k>", require("smart-splits").move_cursor_up)
map("n", "<C-l>", require("smart-splits").move_cursor_right)
map("n", "<C-\\>", require("smart-splits").move_cursor_previous)
map("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
map("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
map("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
map("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

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

require("gruvbox-material").setup({
	italics = true, -- enable italics in general
	contrast = "hard", -- set contrast, can be any of "hard", "medium", "soft"
	comments = {
		italics = true, -- enable italic comments
	},
	background = {
		transparent = transparent, -- set the background to be opaque
	},
	float = {
		force_background = false, -- set to true to force backgrounds on floats even when
		-- background.transparent is set
		background_color = nil, -- set color for float backgrounds. If nil, uses the default color set
		-- by the color scheme
	},
	signs = {
		force_background = false, -- set to true to force backgrounds on signs even when
		-- background.transparent is set
		background_color = nil, -- set color for sign backgrounds. If nil, uses the default color set
		-- by the color scheme
	},
	customize = nil, -- customize the theme in any way you desire, see below what this
	-- configuration accepts
})

function setColorscheme()
	local file_path = vim.fn.stdpath("config") .. "/colorscheme.txt"
	local f = assert(io.open(file_path, "rb"))
	local content = f:read("*all")
	f:close()

	vim.cmd.colorscheme(vim.trim(content))
end

setColorscheme()

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
vim.lsp.enable({
	"lua_ls",
	"rust_analyer",
	"gopls",
	"ts_ls",
	"py_lsp",
	"astro",
	"tailwindcss",
	"svelte",
	"nil_ls",
	"qmlls",
	"clangd",
})

vim.lsp.config("ccls", {
	cmd = { "ccls", '--init={"clang": {"extraArgs": ["-std=c++23", "-Wall", "-Wextra", "-Iinclude"]}}' },
})

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
