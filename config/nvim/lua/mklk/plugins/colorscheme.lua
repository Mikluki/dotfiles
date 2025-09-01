-- This should be in your init.lua or plugins.lua that lazy.nvim loads
return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {}, -- Optional: pass options here
	},

	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "material"
			vim.g.gruvbox_material_foreground = "mix"
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_better_performance = 1
		end,
	},

	-- Apply the colorscheme based on your setting
	{
		"nvim-lua/plenary.nvim", -- dependency to inject config
		priority = 999, -- run after colorschemes loaded
		config = function()
			-- Define your colorschemes table here
			local colorschemes = {
				{
					name = "gruvbox-material",
					background = "dark",
					setup = function()
						vim.g.gruvbox_material_background = "material"
						vim.g.gruvbox_material_foreground = "mix"
						vim.g.gruvbox_material_enable_italic = true
						vim.g.gruvbox_material_better_performance = 1
					end,
				},
				{
					name = "tokyonight-day",
					background = "light",
				},
				{
					name = "tokyonight-night",
					background = "dark",
				},
			}

			-- Set up the keymapping for cycling colorschemes
			vim.keymap.set("n", "<leader>ct", function()
				local current = vim.g.colors_name
				local next_index = 1

				for i, cs in ipairs(colorschemes) do
					if cs.name == current then
						next_index = (i % #colorschemes) + 1
						break
					end
				end

				local next = colorschemes[next_index]

				if next.setup then
					next.setup()
				end
				vim.o.background = next.background
				vim.cmd("colorscheme " .. next.name)
			end, { desc = "Cycle colorscheme" })

			-- Set your preferred default
			local colorscheme = vim.g.preferred_colorscheme or "gruvbox-material"
			vim.cmd("colorscheme " .. colorscheme)
		end,
	},
}
