return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {
		focus = true,
		modes = {
			symbols = {
				desc = "document symbols",
				mode = "lsp_document_symbols",
				focus = true,
				win = {
					position = "right",
					size = 0.4,
				},
			},
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>ds",
			"<cmd>Trouble symbols toggle<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>fu",
			"<cmd>Trouble symbols toggle<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
