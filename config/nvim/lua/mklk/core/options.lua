vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness

-- enable ru layout
opt.langmap =
	"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- folding
opt.foldopen:append("insert")
opt.foldmethod = "manual"
opt.foldlevel = 99
opt.foldlevelstart = 99 -- Start with all folds open
opt.foldminlines = 4
opt.foldcolumn = "0"
opt.foldenable = true

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- ### LINE WRAPPING & LINE BREAK ###
-- Global settings for line wrapping
opt.wrap = false -- Disable wrapping globally
opt.linebreak = true -- Prevent breaking words in the middle
opt.breakindent = true -- Indent wrapped lines visually
opt.showbreak = "  " -- Add visual indentation to wrapped lines

-- FileType-specific settings for Markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.wo.wrap = true -- Enable line wrapping
		vim.wo.linebreak = true -- Prevent word breaks
		vim.wo.breakindent = true -- Maintain indentation on wrapped lines
		vim.wo.showbreak = "  " -- Add indentation to wrapped lines
	end,
})

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- ### APPEARANCE ###
-- cursor line
opt.scrolloff = 6
opt.cursorline = true -- highlight the current cursor line

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 150 })
	end,
})

opt.termguicolors = true -- (have to use iterm2 or any other true color terminal)
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
