return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"python",
				"markdown",
				"markdown_inline",
				"javascript",
				"typescript",
				-- "tsx",
				"yaml",
				"html",
				"css",
				-- "prisma",
				-- "svelte",
				-- "graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				-- "query",
				"vimdoc",
				"rust",
				"c",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-enter>",
					node_incremental = "<C-enter>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
				textobjects = { enable = true },
			},
		})
	end,
}
