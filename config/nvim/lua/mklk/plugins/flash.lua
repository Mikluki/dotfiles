return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "R", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "S", mode = {"n", "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
	config = function()
		local flash = require("flash")
		flash.setup({
			highlight = {
				backdrop = false, -- Disables the shadow effect
			},
			modes = {
				char = {
					highlight = {
						backdrop = false,
					},
				},
			},
			jump = {
				-- when using jump labels, set to 'true' to automatically jump
				-- or execute a motion when there is only one match
				autojump = false,
			},
		})
	end,
}
