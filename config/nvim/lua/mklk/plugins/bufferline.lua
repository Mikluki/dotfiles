return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			always_show_bufferline = false,
			show_buffer_icons = false, -- disables filetype icons
			mode = "tabs",
			separator_style = "slant",
		},
	},
}
