return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			progress = {
				enabled = false, -- disable LSP progress messages
			},
			hover = {
				enabled = true, -- enable hover messages
			},
			signature = {
				enabled = true, -- enable signature help
			},
		},
		routes = {
			-- Hide unkown
			{
				filter = { event = "notify", find = " choose " },
				opts = { skip = true },
			},
			{
				filter = { event = "notify", find = " lines " },
				opts = { skip = true },
			},
			{
				filter = { event = "notify", find = "Scratch" },
				opts = { skip = true },
			},
			{
				filter = { event = "notify", find = "Prompt" },
				opts = { skip = true },
			},
			-- Hide "No information available"
			{
				filter = { event = "notify", find = "No information available" },
				opts = { skip = true },
			},
			-- Suppress indents
			{
				filter = { event = "msg_show", find = "<ed" },
				opts = { skip = true },
			},
			{
				filter = { event = "msg_show", find = ">ed" },
				opts = { skip = true },
			},
			-- Suppress yanked messages
			{
				filter = { event = "msg_show", find = ", job_id" },
				opts = { skip = true },
			},
			-- Suppress yanked & written messages
			{
				filter = { event = "msg_show", find = "yanked" },
				opts = { skip = true },
			},
			{
				filter = { event = "msg_show", find = "written" },
				opts = { skip = true },
			},
			-- Suppress undo/redo messages
			{
				filter = { event = "msg_show", find = "change;" },
				opts = { skip = true },
			},
			{
				filter = { event = "msg_show", find = "%d more line" },
				opts = { skip = true },
			},
			{
				filter = { event = "msg_show", find = "line less" },
				opts = { skip = true },
			},
			{
				filter = { event = "msg_show", find = "%d fewer line" },
				opts = { skip = true },
			},
			{
				filter = { event = "msg_show", find = "Already at oldest" },
				opts = { skip = true },
			},
		},
		presets = {
			command_palette = true, -- position the command line in the status line area
			lsp_doc_border = true,
		},
		-- Key mapping to dismiss notifications
		vim.keymap.set("n", "<leader><Esc>", function()
			require("noice").cmd("dismiss")
		end, { noremap = true, silent = true, desc = "Dismiss all notifications" }),
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
}
