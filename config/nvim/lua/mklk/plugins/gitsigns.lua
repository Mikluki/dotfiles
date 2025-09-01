return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("gitsigns").setup({
			signcolumn = false,
			auto_attach = true,

			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				-- Helper function for setting keymaps
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				map("n", "<leader>jh", gs.next_hunk, "Next Hunk")
				map("n", "<leader>hn", gs.next_hunk, "Next Hunk")
				map("n", "<leader>kh", gs.prev_hunk, "Prev Hunk")
				map("n", "<leader>hp", gs.prev_hunk, "Prev Hunk")

				-- Actions (grouped by prefix for better organization)
				-- Staging/unstaging
				map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

				-- Reset
				map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
				map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

				-- Visual mode staging/resetting
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage selected lines")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset selected lines")

				-- Preview and info
				map("n", "<leader>hf", gs.preview_hunk, "Preview hunk") -- "f" for float
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")

				-- Diff views
				map("n", "<leader>hd", gs.diffthis, "Diff this")
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, "Diff this ~")

				-- Text object (for operations like yank, delete)
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")

				map("n", "<leader>ht", function()
					gs.toggle_signs()
				end, "Toggle GitSigns")
			end,
		})
	end,
}
