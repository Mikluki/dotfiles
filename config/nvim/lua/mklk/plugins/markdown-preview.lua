return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown", "tex" },
	build = function()
		vim.cmd([[Lazy load markdown-preview.nvim]])
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		-- Enable commands for all filetypes (this is the key!)
		vim.g.mkdp_command_for_global = 1

		-- Set recognized filetypes (this controls syntax highlighting)
		vim.g.mkdp_filetypes = { "markdown", "tex" }

		-- Set keymap to stop Markdown preview
		vim.api.nvim_set_keymap("n", "<leader>mq", ":MarkdownPreviewStop<CR>", { noremap = true, silent = true })

		-- Define browser functions
		vim.cmd([[
            function! OpenMarkdownPreviewApp(url)
                call jobstart(["brave-browser", "--app=" . a:url], {"detach": v:true})
            endfunction
        ]])

		-- Define OpenMarkdownPreviewTab function for tab mode
		vim.cmd([[
            function! OpenMarkdownPreviewTab(url)
                call jobstart(["brave-browser", "--new-window", a:url], {"detach": v:true})
            endfunction
        ]])

		-- Create command for opening in app mode
		vim.cmd([[
            function! StartMarkdownPreviewApp()
                let g:mkdp_browserfunc = "OpenMarkdownPreviewApp"
                MarkdownPreview
            endfunction
            command! MarkdownPreviewApp call StartMarkdownPreviewApp()
        ]])

		-- Create command for opening in tab mode
		vim.cmd([[
            function! StartMarkdownPreviewTab()
                let g:mkdp_browserfunc = "OpenMarkdownPreviewTab"
                MarkdownPreview
            endfunction
            command! MarkdownPreviewTab call StartMarkdownPreviewTab()
        ]])

		-- Set keymaps
		vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreviewApp<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>mo", ":MarkdownPreviewTab<CR>", { noremap = true, silent = true })
	end,
}
