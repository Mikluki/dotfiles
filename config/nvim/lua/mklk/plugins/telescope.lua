return {
	"nvim-telescope/telescope.nvim",
	-- branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local ts_actions = require("telescope.actions")
		require("telescope.utils")
		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = ts_actions.move_selection_previous, -- move to prev result
						["<C-j>"] = ts_actions.move_selection_next, -- move to next result
						["<C-q>"] = ts_actions.send_to_qflist + ts_actions.open_qflist,
						["<C-w>"] = ts_actions.send_selected_to_qflist + ts_actions.open_qflist,
						["<C-c>"] = ts_actions.delete_buffer, -- Close selected buffer
						["<Tab>"] = ts_actions.toggle_selection + ts_actions.move_selection_worse,
						["<S-Tab>"] = ts_actions.toggle_selection + ts_actions.move_selection_better,
					},
					n = {
						["<C-q>"] = ts_actions.send_to_qflist + ts_actions.open_qflist,
						["<C-w>"] = ts_actions.send_selected_to_qflist + ts_actions.open_qflist,
						["<Tab>"] = ts_actions.toggle_selection + ts_actions.move_selection_worse,
						["<S-Tab>"] = ts_actions.toggle_selection + ts_actions.move_selection_better,
						["<C-c>"] = ts_actions.delete_buffer, -- Close selected buffer
					},
				},
			},
			pickers = {
				diagnostics = {
					layout_config = {
						width = 0.9, -- Make diagnostics picker wider (90% of screen)
						preview_width = 0.5,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		local telescope_builtin = require("telescope.builtin")
		keymap.set("n", "<leader>fx", "<cmd>Telescope diagnostics<cr>", { desc = "Find diagnostics worksapce" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })

		keymap.set("n", "<leader>fn", function()
			telescope_builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find Neovim files" })

		-- SEARCH FOR SYMBOLS
		local symbol_filter = { -- Define symbols filter once to reuse
			symbols = { "method", "function", "class" },
			sorting_strategy = "ascending", -- Ensures order follows LSP
		}

		-- Map for document symbols
		keymap.set("n", "<leader>fd", function()
			-- Ensure we're working with the current buffer
			vim.api.nvim_command("noautocmd normal! m`") -- Set a mark to return to
			local current_buf = vim.api.nvim_get_current_buf()

			-- Force telescope to use the current buffer
			telescope_builtin.lsp_document_symbols(vim.tbl_extend("force", symbol_filter, {
				bufnr = current_buf,
			}))
		end, { noremap = true, silent = true, desc = "Find LSP Document Symbols" })

		keymap.set("n", "<leader>fD", function()
			telescope_builtin.lsp_dynamic_workspace_symbols(symbol_filter)
		end, { noremap = true, silent = true, desc = "Find LSP Workspace Symbols" })

		-- SEARCH FILES INLCUDING THOSE IN GITIGNORE
		keymap.set(
			"n",
			"<leader>fi",
			"<cmd>Telescope find_files find_command=fd,--type,f,--hidden,--no-ignore<cr>",
			{ desc = "Find ignored files" }
		)

		-- SEARCH EXISTING MARKS
		keymap.set("n", "<leader>fm", function()
			telescope_builtin.marks()
		end, { desc = "Find existing marks" })

		-- GREP FILES WITH RIPGREP
		require("mklk.plugins.telescope.multigrep").setup()

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
				sorting_strategy = "ascending", -- Keeps order as in the buffer
			}))
		end, { desc = "[/] Find in current buffer" })

		-- GIT HISTORY SEARCH
		vim.api.nvim_create_user_command("GitHistoryFile", function()
			require("telescope.builtin").git_bcommits({
				layout_strategy = "horizontal",
				layout_config = {
					width = function(_, cols, _)
						return cols
					end,
					height = function(_, _, rows)
						return rows
					end,
					preview_cutoff = 0, -- Always show preview
					preview_width = 0.6, -- This works with horizontal layout
				},
			})
		end, {})
		keymap.set("n", "<leader>gh", "<cmd>GitHistoryFile<cr>", { desc = "Find Git history for a file" })

		-- GIT_STATUS PICKER WITH HORIZONTAL SPLIT
		vim.api.nvim_create_user_command("FullGitStatus", function()
			require("telescope.builtin").git_status({
				layout_strategy = "horizontal",
			})
		end, {})
		keymap.set("n", "<leader>gs", "<cmd>FullGitStatus<cr>", { desc = "Find Git Status" })

		-- FIND GIT HUNKS
		require("mklk.plugins.telescope.githunk-search").setup()
	end,
}
