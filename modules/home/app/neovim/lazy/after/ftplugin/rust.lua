local opts = { buffer = true, silent = true }

vim.keymap.set("n", "<leader>cb", "<cmd>Compile cargo build<cr>", opts)
vim.keymap.set("n", "<leader>cr", "<cmd>Compile cargo run<cr>", opts)
vim.keymap.set("n", "<leader>ct", "<cmd>Compile cargo test<cr>", opts)
vim.keymap.set("n", "<leader>cc", "<cmd>Compile cargo clippy -- -W clippy::all -W clippy::pedantic<cr>", opts)
vim.keymap.set("n", "<leader>cC", "<cmd>Compile cargo check<cr>", opts)
vim.keymap.set(
	"n",
	"<leader>cf",
	"<cmd>Compile cargo clippy --fix --allow-dirty -- -W clippy::all -W clippy::pedantic<cr>",
	opts
)
