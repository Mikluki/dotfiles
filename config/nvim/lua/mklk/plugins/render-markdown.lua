return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
	config = function()
		require("render-markdown").setup({
			latex = { enabled = false },
			win_options = { conceallevel = { rendered = 2 } },
			heading = {
				backgrounds = {},
				sign = false,
				border = true,
				below = "▔",
				above = "▁",
				left_pad = 0,
				position = "left",
				icons = {
					" ",
					" ",
					" ",
					" ",
					" ",
					" ",
				},
			},
			bullet = {
				enabled = true,
				icons = { "", "", "◆", "◇" },
				-- icons = { "●", "○", "◆", "◇" },
				ordered_icons = function(ctx)
					local value = vim.trim(ctx.value)
					local index = tonumber(value:sub(1, #value - 1))
					return string.format("%d.", index > 1 and index or ctx.index)
				end,
				-- Padding to add to the left of bullet point
				left_pad = 0,
				-- Padding to add to the right of bullet point
				right_pad = 0,
				-- Highlight for the bullet icon
				highlight = "RenderMarkdownBullet",
			},
			-- -- WITH BACKGROUND COLOR
			-- heading = {
			-- 	sign = false,
			-- 	border = true,
			-- 	below = "▔",
			-- 	above = "▁",
			-- 	left_pad = 0,
			-- 	position = "left",
			-- 	icons = {
			-- 		" ",
			-- 		" ",
			-- 		" ",
			-- 		" ",
			-- 		" ",
			-- 		" ",
			-- 	},
			-- },
		})
	end,
}
