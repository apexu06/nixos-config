return {
	{
		"https://github.com/mfussenegger/nvim-dap",
		dependencies = {},
		event = "VeryLazy",
		config = function()
			local dap = require("dap")

			dap.adapters.lldb = {
				type = "executable",
				command = vim.fn.exepath("lldb-dap"),
				name = "lldb",
			}

			dap.configurations.c = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					args = {}, -- provide arguments if needed
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Select and attach to process",
					type = "gdb",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Attach to gdbserver :1234",
					type = "gdb",
					request = "attach",
					target = "localhost:1234",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.cpp = dap.configurations.c

			dap.configurations.rust = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					args = function()
						return vim.split(vim.fn.input("Args: "), " ")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					runInTerminal = true,
					initCommands = function()
						local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
						assert(
							vim.v.shell_error == 0,
							"failed to get rust sysroot using `rustc --print sysroot`: " .. rustc_sysroot
						)
						local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
						local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
						return {
							([[!command script import '%s']]):format(script_file),
							([[command source '%s']]):format(commands_file),
						}
					end,
				},
				{
					name = "Select and attach to process",
					type = "lldb",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Attach to gdbserver :1234",
					type = "lldb",
					request = "attach",
					target = "localhost:1234",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}
		end,
	},
	{
		"https://github.com/igorlfs/nvim-dap-view",
		event = "BufReadPost *.*",
		config = function()
			require("dap-view").setup({
				auto_toggle = true,
				winbar = {
					sections = { "watches", "scopes", "breakpoints", "threads", "repl", "console" },
					controls = {
						enabled = true,
					},
				},
				virtual_text = {
					enabled = true,
				},
			})
		end,
	},
}
