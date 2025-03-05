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
				"latex",
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

				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["<leader>jf"] = { query = "@call.outer", desc = "Next function call start" },
						["<leader>jm"] = { query = "@function.outer", desc = "Next method/function def start" },
						["<leader>jc"] = { query = "@class.outer", desc = "Next class start" },
						["<leader>ji"] = { query = "@conditional.outer", desc = "Next conditional start" },
						["<leader>jl"] = { query = "@loop.outer", desc = "Next loop start" },

						["<leader>jz"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_previous_start = {
						["<leader>kf"] = { query = "@call.outer", desc = "Prev function call start" },
						["<leader>km"] = { query = "@function.outer", desc = "Prev method/function def start" },
						["<leader>kc"] = { query = "@class.outer", desc = "Prev class start" },
						["<leader>ki"] = { query = "@conditional.outer", desc = "Prev conditional start" },
						["<leader>kl"] = { query = "@loop.outer", desc = "Prev loop start" },

						["<leader>kz"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["<leader>jF"] = { query = "@call.outer", desc = "Next function call end" },
						["<leader>jM"] = { query = "@function.outer", desc = "Next method/function def end" },
						["<leader>jC"] = { query = "@class.outer", desc = "Next class end" },
						["<leader>jI"] = { query = "@conditional.outer", desc = "Next conditional end" },
						["<leader>jL"] = { query = "@loop.outer", desc = "Next loop end" },
					},
					goto_previous_end = {
						["<leader>kF"] = { query = "@call.outer", desc = "Prev function call end" },
						["<leader>kM"] = { query = "@function.outer", desc = "Prev method/function def end" },
						["<leader>kC"] = { query = "@class.outer", desc = "Prev class end" },
						["<leader>kI"] = { query = "@conditional.outer", desc = "Prev conditional end" },
						["<leader>kL"] = { query = "@loop.outer", desc = "Prev loop end" },
					},
				},

				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
						["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
						["t="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
						["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

						["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
						["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

						["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

						["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
						["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

						["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
						["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

						["am"] = {
							query = "@function.outer",
							desc = "Select outer part of a method/function definition",
						},

						["im"] = {
							query = "@function.inner",
							desc = "Select inner part of a method/function definition",
						},

						["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
					},

					swap = {
						enable = true,
						swap_next = {
							["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
							["<leader>nm"] = "@function.outer", -- swap function with next
						},
						swap_previous = {
							["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
							["<leader>pm"] = "@function.outer", -- swap function with previous
						},
					},
				},
			},
		})

		-- Repeat movement with ; and ,
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
		vim.keymap.set({ "n", "x", "o" }, "<leader>;", ts_repeat_move.repeat_last_move_next)
		vim.keymap.set({ "n", "x", "o" }, "<leader>,", ts_repeat_move.repeat_last_move_previous)
	end,
}
