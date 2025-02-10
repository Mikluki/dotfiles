return -- install without yarn or npm
{
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.cmd([[Lazy load markdown-preview.nvim]])
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		-- Set keymap to toggle Markdown preview with <leader>mp
		vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>mq", ":MarkdownPreviewStop<CR>", { noremap = true, silent = true })
	end,
}
