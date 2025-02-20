return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		-- Load todo-comments
		local todo_comments = require("todo-comments")

		-- Setup todo-comments with custom options
		todo_comments.setup({
			signs = true, -- show icons in the signs column
			sign_priority = 8, -- sign priority
			-- keywords recognized as todo comments
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- alternative keywords
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
				TAG = { icon = " ", color = "hint", alt = { "TAG" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		})

		-- Set keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader>tj", function()
			todo_comments.jump_next()
		end, { desc = "Todo next comment" })

		keymap.set("n", "<leader>tk", function()
			todo_comments.jump_prev()
		end, { desc = "Todo previous comment" })
	end,
}
