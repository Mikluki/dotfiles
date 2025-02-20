return {
	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{ "kevinhwang91/promise-async", lazy = true },
		},
		opts = {
			preview = {
				mappings = {
					scrollB = "<C-B>",
					scrollF = "<C-F>",
					scrollU = "<C-U>",
					scrollD = "<C-D>",
				},
			},
			provider_selector = function(_, filetype, buftype)
				local function handleFallbackException(bufnr, err, providerName)
					if type(err) == "string" and err:match("UfoFallbackException") then
						return require("ufo").getFolds(bufnr, providerName)
					else
						return require("promise").reject(err)
					end
				end

				return (filetype == "" or buftype == "nofile") and "indent"
					or function(bufnr)
						return require("ufo")
							.getFolds(bufnr, "lsp")
							:catch(function(err)
								return handleFallbackException(bufnr, err, "treesitter")
							end)
							:catch(function(err)
								return handleFallbackException(bufnr, err, "indent")
							end)
					end
			end,
		},
		config = function(_, opts)
			require("ufo").setup(opts)

			-- Keybindings
			vim.keymap.set("n", "zL", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zl", require("ufo").openFoldsExceptKinds, { desc = "Fold less" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zm", require("ufo").closeAllFolds, { desc = "Fold more" })
			vim.keymap.set("n", "zp", require("ufo").peekFoldedLinesUnderCursor, { desc = "Peek fold" })
		end,
	},
}
