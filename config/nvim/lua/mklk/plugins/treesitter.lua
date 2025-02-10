return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				"json",
				"python",
				"markdown",
				"markdown_inline",
				"javascript",
				"typescript",
				"yaml",
				"html",
				"css",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"vimdoc",
				"rust",
				"c",
			},
			sync_install = false, -- Set to true if you want to install parsers synchronously
			auto_install = true, -- Automatically install missing parsers
			ignore_install = {}, -- List of parsers to ignore installing
			modules = {}, -- Required, but can be left empty for default behavior
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<space>v",
					node_incremental = "<space>v",
					node_decremental = "<space>b",
					scope_incremental = false,
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj
					keymaps = {
						["af"] = { query = "@function.outer", desc = "Select around function" },
						["if"] = { query = "@function.inner", desc = "Select inside function" },
						["ac"] = { query = "@class.outer", desc = "Select around class" },
						["ic"] = { query = "@class.inner", desc = "Select inside class" },
					},
				},
			},
		})
	end,
}
