require("config.lazy")

---@diagnostic disable: deprecated
vim.opt.number = true
vim.opt.undofile = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.splitbelow = true
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
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.md", "*.tex" },
	callback = function()
		vim.cmd("setlocal textwidth=100")
		vim.cmd("setlocal colorcolumn=100")
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions[1].type == "move" then
			Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
		end
	end,
})

function setColorscheme()
	local file_path = vim.fn.stdpath("config") .. "/colorscheme.txt"
	local f = assert(io.open(file_path, "rb"))
	local content = f:read("*all")
	f:close()

	vim.cmd.colorscheme(vim.trim(content))
end

setColorscheme()

local function open_file_picker_in_split(direction)
	require("snacks").picker.files({
		confirm = function(picker, item)
			picker:close()
			if item then
				if direction == "horizontal" then
					vim.cmd("split " .. item.file)
				else
					vim.cmd("vsplit " .. item.file)
				end
			end
		end,
	})
end

-- Keymaps

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

-- require("nvim-treesitter").install({ "rust", "javascript", "zig", "cpp", "nix", "typescript", "html" })

local map = vim.keymap.set

map("n", "<leader>w", ":write<CR>")
map("n", "<leader>s", ":update<CR> :source<CR>")
map("n", "<leader>o", "<CMD>Oil<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
map("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })

map("n", "<leader>q", ":copen<CR>")
map("n", "ge", vim.diagnostic.goto_next)
map("n", "<leader>mr", ":make run<CR>")
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "<leader>q", vim.diagnostic.setloclist)
map("n", "L", ":bnext<CR>", { noremap = true, silent = true })
map("n", "H", ":bprev<CR>", { noremap = true, silent = true })
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
map("n", "<leader>sf", function()
	Snacks.picker.files()
end)
map("n", "<leader>sg", function()
	Snacks.picker.grep()
end)
map("n", "<leader>sb", function()
	Snacks.picker.buffers()
end)
map("n", "<leader>gd", function()
	Snacks.picker.lsp_definitions()
end)
map("n", "<leader>gD", function()
	Snacks.picker.lsp_declarations()
end)
map("n", "<leader>gI", function()
	Snacks.picker.lsp_implementations()
end)
map("n", "<leader>gy", function()
	Snacks.picker.lsp_type_definitions()
end)
map("n", "<leader>gr", function()
	Snacks.picker.lsp_references()
end)
map("n", "<leader>b", function()
	Snacks.bufdelete()
end)
map("n", "<leader>lg", function()
	Snacks.lazygit()
end)

map("n", "<leader>v", function()
	open_file_picker_in_split("vertical")
end, { desc = "Pick file in vertical split" })

map("n", "<leader>h", function()
	open_file_picker_in_split("horizontal")
end, { desc = "Pick file in horizontal split" })
