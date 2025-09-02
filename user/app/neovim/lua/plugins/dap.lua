function setup_listeners(dap, dapui)
	dapui.setup()
	dap.listeners.before.attach.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
		dapui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		dapui.close()
	end
end

function setup_go(dap)
	dap.adapters.go = {
		type = "executable",
		command = "node",
		args = { vim.fn.stdpath("config") .. "/debuggers/go/debugAdapter.js" },
	}

	dap.configurations.go = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
			showLog = false,
			program = "${file}",
			dlvToolPath = vim.fn.exepath("dlv"),
		},
	}
end

function setup_rust(dap)
	dap.adapters.lldb = {
		type = "executable",
		command = "/usr/bin/lldb-dap",
		name = "lldb",
	}

	dap.configurations.rust = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},

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
	}
end

function setup_js(dap)
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = { vim.fn.stdpath("config") .. "/debuggers/js/dapDebugServer.js", "${port}" },
		},
	}

	dap.configurations.javascript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
	}

	dap.configurations.typescript = dap.configurations.javascript
end

return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		require("nvim-dap-virtual-text").setup()

		require("dap-python").setup("python3")

		setup_listeners(dap, dapui)
		setup_go(dap)
		setup_rust(dap)
		setup_js(dap)

		vim.keymap.set("n", "<leader>dd", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>dc", dap.continue)
		vim.keymap.set("n", "<leader>do", dap.step_over)
		vim.keymap.set("n", "<leader>di", dap.step_into)
		vim.keymap.set("n", "<leader>dk", dap.disconnect)
		vim.keymap.set("n", "<leader>du", dapui.toggle)
	end,
}
