return {
	"rcarriga/nvim-notify",
	opts = {
		timeout = 1000,
	},
	config = function()
		vim.keymap.set("n", "<leader>f.", function()
			require("telescope").extensions.notify.notify()
		end, { desc = "Open notification history with Telescope" })
	end,
}
