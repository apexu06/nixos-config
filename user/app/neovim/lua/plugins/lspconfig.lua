return {
	event = "VeryLazy",
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{
			"j-hui/fidget.nvim",
			opts = {
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
			},
		},
	},
	config = function()
		local lspconfig = require("lspconfig")

		local is_nixos = false
    local f = io.open("/etc/os-release", "r")
    if f then
        local content = f:read("*a")
        f:close()
        if content:match("ID=nixos") then
            is_nixos = true
        end
    end

		local servers = {
			lua_ls = {
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
			},
			rust_analyzer = {},
			gopls = {},
			clangd = {},
			gopls = {},
			ts_ls = {},
			pylsp = {},
			bashls = {},
		}


		if not is_nixos then 
		  require("mason").setup()
		  local ensure_installed = vim.tbl_keys(servers or {})
		  vim.list_extend(ensure_installed, {
		  	"stylua",
		  	"prettierd",
		  })

		  require("mason-tool-installer").setup({
		  	ensure_installed = ensure_installed,
		  })

		  require("mason-lspconfig").setup({
		  	automatic_enable = true,
		  	automatic_installation = {},
		  	ensure_installed = {},
		  	handlers = {
		  		function(server_name)
		  			local server = servers[server_name] or {}
		  			server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities)
		  			require("lspconfig")[server_name].setup(server)
		  		end,
		  	},
		  })
		else 
			lspconfig.nil_ls.setup{}

			for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = require("blink.cmp").get_lsp_capabilities(server_opts.capabilities)
        lspconfig[server_name].setup(server_opts)
      end
		end

		vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
	end,
}
