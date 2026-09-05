require("config.lazy")
require("config.options")
require("config.keymap")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.md", "*.tex", "*.typ" },
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

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*compilation*",
	callback = function()
		local win = vim.fn.bufwinid(vim.fn.bufnr("*compilation*"))
		if win ~= -1 then
			vim.api.nvim_win_set_height(win, math.floor(vim.o.lines / 4))
		end
	end,
})

local yazi_watch_timer = nil

local function watch_yazi_terminal_mode(buf)
	if yazi_watch_timer then
		yazi_watch_timer:stop()
		yazi_watch_timer:close()
	end
	yazi_watch_timer = vim.loop.new_timer()
	yazi_watch_timer:start(
		0,
		200,
		vim.schedule_wrap(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				yazi_watch_timer:stop()
				yazi_watch_timer:close()
				yazi_watch_timer = nil
				return
			end
			if vim.api.nvim_get_current_buf() == buf and vim.fn.mode() == "n" then
				vim.cmd("startinsert")
			end
		end)
	)
end

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function(args)
		-- scope to floating terminal windows only (yazi's window is floating;
		-- this avoids touching normal :terminal splits where Normal-mode
		-- scrollback browsing is legitimately useful)
		local win = vim.fn.bufwinid(args.buf)
		if win ~= -1 and vim.api.nvim_win_get_config(win).relative ~= "" then
			watch_yazi_terminal_mode(args.buf)
		end
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
		env = "dotenv",
	},
	filename = {
		[".env"] = "dotenv",
		["env"] = "dotenv",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})
