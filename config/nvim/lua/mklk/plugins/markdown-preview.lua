return {
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

		-- Define OpenMarkdownPreview function
		-- vim.cmd([[
		-- 	function! OpenMarkdownPreview(url)
		-- 		call jobstart(["brave-browser", "--new-window", a:url], {"detach": v:true})
		-- 	endfunction
		-- ]])

		vim.cmd([[
      function! OpenMarkdownPreview(url)
          call jobstart(["brave-browser", "--app=" . a:url], {"detach": v:true})
      endfunction
		]])

		-- Set the function for markdown-preview.nvim
		vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
	end,
}
