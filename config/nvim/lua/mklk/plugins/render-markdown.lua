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
				ordered_icons = function(level, index, value)
					value = vim.trim(value)
					local value_index = tonumber(value:sub(1, #value - 1))
					return string.format("%d.", value_index > 1 and value_index or index)
				end,
				left_pad = 0,
				right_pad = 0,
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
