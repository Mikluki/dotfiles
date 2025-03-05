-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

--=========================--
-- ### GENERAL KEYMAPS ### --

-- use jj tofexit insert mode
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- clear search highlights
keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<ESC>", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- Paste without overwrite
keymap.set("v", "p", "P", opts)
-- Undo quicker
keymap.set("n", "U", "<cmd>redo<CR>", opts)

-- ### QUICKFIX
keymap.set("n", "<leader>jj", "<cmd>cnext<CR>", { desc = "Quickfix Next" })
keymap.set("n", "<leader>kk", "<cmd>cprev<CR>", { desc = "Quickfix Prev" })
keymap.set("n", "<leader>cj", "<cmd>cnext<CR>", { desc = "Quickfix Next" })
keymap.set("n", "<leader>ck", "<cmd>cprev<CR>", { desc = "Quickfix Prev" })
keymap.set("n", "<leader>co", "<cmd>copen<CR>", { desc = "Quickfix Open" })
keymap.set("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Quickfix Close" })

-- ### BUFFER SAVE & CLOSE ###
-- keymap.set("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Explorer" })
keymap.set("n", "<leader>w", "<cmd>wa<CR>", { desc = "Save all" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close buffer" })
keymap.set("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Close all" })
keymap.set("n", "<leader>X", "<cmd>bufdo bd!<CR>", { desc = "Close all" })

-- ### SPLIT MANAGEMENT ###
-- ## SPLITS ##
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>sd", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

-- Resize splits using arrow keys + Control
keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- ## TABS ##
keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- keymap.set("n", "<leader>td", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

keymap.set("n", "<M-k>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<M-j>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab

-- ## REPLACE SELECTION ##
keymap.set(
	"v",
	"<leader>s",
	'"hy:%s/<C-r>h//gc<left><left><left>',
	{ noremap = true, silent = true, desc = "substitute selection" }
)

-- Run macro bound to q with Q
keymap.set("n", "Q", "@q", opts)

-- ## PAGE NAVIAGTION ##
keymap.set("v", "j", "gj", opts)
keymap.set("v", "k", "gk", opts)
keymap.set("n", "j", "gj", opts)
keymap.set("n", "k", "gk", opts)

-- ## EOF SHORTCUTS ##
keymap.set("n", "L", "$", opts)
keymap.set("n", "H", "^", opts)
keymap.set("v", "L", "$", opts)
keymap.set("v", "H", "^", opts)

local function conditional_map(key, replacement)
	return function()
		local op = vim.v.operator
		if op == "d" or op == "y" then
			return replacement
		end
		return key
	end
end

keymap.set("o", "l", conditional_map("l", "$"), { expr = true })
keymap.set("o", "h", conditional_map("h", "^"), { expr = true })

-- ### CENTERING CONTENT ###
-- centering jumps
keymap.set("v", "gg", "ggzz", opts)
keymap.set("n", "gg", "ggzz", opts)
-- When you search, center the result and open any folds
keymap.set("n", "n", "nzzzv", opts)
-- When you search backwards, center the result and open any folds
keymap.set("n", "N", "Nzzzv", opts)

-- Keep the cursor in the same place when joining or breaking lines
keymap.set("n", "J", "mzgJ`z", { noremap = true, silent = true, desc = "Join lines" })
keymap.set("n", "K", "mza<CR><Esc>`z", { noremap = true, silent = true, desc = "Break line" })

-- #######################
-- ##### CUSTOM UTIL #####
-- #######################

-- ### FILES & BUFFERS ###
-- Delete current file in buffer with confirmation and clse buffer
keymap.set(
	"n",
	"<Leader>df",
	[[:lua DeleteCurrentFile()<CR>]],
	{ noremap = true, silent = true, desc = "Delete current File" }
)

function DeleteCurrentFile()
	local file = vim.fn.expand("%") -- Get current file name
	if file == "" or vim.fn.filereadable(file) == 0 then
		print("No valid file to delete.")
		return
	end

	local confirm = vim.fn.input("Delete " .. file .. "? (y/n) ")
	if confirm == "y" then
		vim.fn.system("rm " .. vim.fn.shellescape(file)) -- Delete file safely
		vim.cmd("bdelete!") -- Close buffer
		print("File deleted: " .. file)
	else
		print("File deletion cancelled.")
	end
end

-- ### MARKDOWN ###
---------------------------
-- TOGGLE MARKDOWN CHECKBOX
keymap.set(
	"n",
	"<leader>mt",
	[[<cmd>lua ToggleMarkdownCheckbox()<CR>]],
	{ noremap = true, silent = true, desc = " Md toggle checkbox" }
)

function ToggleMarkdownCheckbox()
	local line = vim.api.nvim_get_current_line()
	local new_line = line

	if string.match(line, "%- %[ %]") then
		new_line = string.gsub(line, "%- %[ %]", "- [x]")
	elseif string.match(line, "%- %[x%]") then
		new_line = string.gsub(line, "%- %[x%]", "- [ ]")
	end

	vim.api.nvim_set_current_line(new_line)
end

-----------------------------------------------------------
-- FUNCTION TO SUBSTITUTE LATEX MATH DELIMITERS IN MARKDOWN
function MdFormatLatex()
	local start_pos, end_pos
	local mode = vim.fn.mode()

	if mode == "v" or mode == "V" then
		-- Get range from visual selection
		start_pos = vim.api.nvim_buf_get_mark(0, "<") -- Start of visual selection
		end_pos = vim.api.nvim_buf_get_mark(0, ">") -- End of visual selection
	else
		-- Apply to entire file in normal mode
		start_pos = { 1, 0 }
		end_pos = { vim.api.nvim_buf_line_count(0), 0 }
	end

	-- Get the selected or entire lines
	local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

	-- Perform substitutions
	for i, line in ipairs(lines) do
		line = line
			:gsub("\\%( ", "$") -- Replace \( and "\( " with "$"
			:gsub(" \\%)", "$") -- Replace \) and "\) " with "$"
			:gsub("\\%(", "$") -- Replace \( and "\( " with "$"
			:gsub("\\%)", "$") -- Replace \) and "\) " with "$"
			:gsub("\\%[", "$$") -- Replace \[ with "$$"
			:gsub("\\%]", "$$") -- Replace \] with "$$"

		lines[i] = line
	end

	-- Update buffer with modified lines
	vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, end_pos[1], false, lines)
end

-- Keymap for normal mode: apply on whole file
vim.keymap.set(
	{ "v", "n" },
	"<leader>mf",
	"<cmd>lua MdFormatLatex()<CR>",
	{ noremap = true, silent = true, desc = "Format MD math to Tex math" }
)

-----------------------------------------
-- COMPILE MARKDOWN TO PDF standard arial
function MdCompileArial()
	local input_file = vim.fn.expand("%:p") -- Get full path of the current file
	local input_dir = vim.fn.expand("%:p:h") -- Get directory of the current file
	local output_file = input_file:gsub("%.md$", ".pdf") -- Change extension to .pdf

	-- Run Pandoc asynchronously to generate PDF
	vim.fn.jobstart({
		"pandoc",
		input_file,
		"-o",
		output_file,
		"--pdf-engine=xelatex",
		"-V",
		"mainfont=Arial",
		"-V",
		"--resource-path=" .. input_dir, -- Add resource path
	}, {
		detach = true,
		cwd = input_dir, -- Set working directory
		on_exit = function(_, code, _)
			if code == 0 then
				print("PDF compiled successfully: " .. output_file)
			else
				print("Error compiling PDF.")
			end
		end,
	})
end

keymap.set(
	"n",
	"<leader>mcs",
	[[<cmd>lua MdCompileArial()<CR>]],
	{ noremap = true, silent = true, desc = "Compile MD to pdf (standard Arial)" }
)

--------------------------------
-- COMPILE MARKDOWN TO PDF arial
function MdCompileArialNarrow()
	local input_file = vim.fn.expand("%:p") -- Get full path of the current file
	local input_dir = vim.fn.expand("%:p:h") -- Get directory of the current file
	local output_file = input_file:gsub("%.md$", ".pdf") -- Change extension to .pdf

	-- Run Pandoc asynchronously to generate PDF
	vim.fn.jobstart({
		"pandoc",
		input_file,
		"-o",
		output_file,
		"--pdf-engine=xelatex",
		"-V",
		"mainfont=Arial",
		"--variable",
		"geometry:margin=0.7in",
		"--resource-path=" .. input_dir, -- Add resource path
	}, {
		detach = true,
		cwd = input_dir, -- Set working directory
		on_exit = function(_, code, _)
			if code == 0 then
				print("PDF compiled successfully: " .. output_file)
			else
				print("Error compiling PDF.")
			end
		end,
	})
end

keymap.set(
	"n",
	"<leader>mca",
	[[<cmd>lua MdCompileArialNarrow()<CR>]],
	{ noremap = true, silent = true, desc = "Compile MD to pdf (narrow Arial)" }
)

-------------------------------------
-- COMPILE MARKDOWN TO PDF HEADER.TEX
function MdCompileHeaderTex()
	local input_file = vim.fn.expand("%:p")
	local input_dir = vim.fn.expand("%:p:h")
	local output_file = input_file:gsub("%.md$", ".pdf")
	local header_file = input_dir .. "/header.tex"

	-- Check if header.tex exists
	if vim.fn.filereadable(header_file) == 0 then
		print("Error: header.tex not found in " .. input_dir)
		return
	end

	-- Run Pandoc asynchronously to generate PDF
	vim.fn.jobstart({
		"pandoc",
		input_file,
		"-o",
		output_file,
		"--pdf-engine=xelatex",
		"-V",
		"mainfont=Arial",
		"--include-in-header=header.tex",
	}, {
		detach = true,
		cwd = input_dir,
		on_exit = function(_, code, _)
			if code == 0 then
				print("PDF compiled successfully: " .. output_file)
			else
				print("Error compiling PDF.")
			end
		end,
	})
end

keymap.set(
	"n",
	"<leader>mch",
	[[<cmd>lua MdCompileHeaderTex()<CR>]],
	{ noremap = true, silent = true, desc = "Compile MD to pdf [include header.tex]" }
)

-----------------------------------
-- COMPILE MARKDOWN TO PDF via HTML
function MdCompileWebHtml()
	local input_file = vim.fn.expand("%:p")
	local input_dir = vim.fn.expand("%:p:h")
	local output_file = input_file:gsub("%.md$", ".pdf")

	vim.fn.jobstart({
		"pandoc",
		input_file,
		"-o",
		output_file,
		"--pdf-engine=wkhtmltopdf",
		"--resource-path=" .. input_dir,
		"--pdf-engine-opt=--enable-local-file-access",
	}, {
		detach = true,
		cwd = input_dir,
		on_exit = function(_, code, _)
			if code == 0 then
				print("PDF compiled successfully: " .. output_file)
			else
				print("Error compiling PDF.")
			end
		end,
	})
end

keymap.set(
	"n",
	"<leader>mcw",
	[[<cmd>lua MdCompileWebHtml()<CR>]],
	{ noremap = true, silent = true, desc = "Compile MD to PDF [Web html]" }
)

-- OPEN IN SIOYEK
function OpenPDFWithSioyek()
	local file = vim.fn.expand("%:p") -- Get the full path of the current file
	local pdf_file = file:gsub("%.md$", ".pdf"):gsub("%.tex$", ".pdf") -- Replace .md or .tex with .pdf

	-- Check if the corresponding PDF file exists
	if vim.fn.filereadable(pdf_file) == 1 then
		-- Run sioyek asynchronously
		vim.fn.jobstart({ "sioyek", "--new-window", pdf_file }, { detach = true })
	else
		print("PDF not found: " .. pdf_file)
	end
end

keymap.set(
	"n",
	"<leader>ms",
	[[<cmd>lua OpenPDFWithSioyek()<CR>]],
	{ noremap = true, silent = true, desc = "Open md or tes with sioyek" }
)

-- TOGGLE LINE WRAPPING
keymap.set("n", "<leader>tw", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrapping " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle line wrapping" })

-- Yank path of current file
keymap.set(
	"n",
	"<leader>yp",
	[[:let @+ = expand('%:p')<CR>]],
	{ noremap = true, silent = true, desc = "Yank path of the current file" }
)

-- OPEN NEMO AT CURRENT FILE
keymap.set(
	"n",
	"<leader>nm",
	[[<cmd>lua OpenNemoAtFile()<CR>]],
	{ noremap = true, silent = true, desc = "Open Nemo at current file location" }
)

function OpenNemoAtFile()
	local filepath = vim.fn.expand("%:p")
	if filepath == "" then
		print("No file opened")
		return
	end
	local dir = vim.fn.fnamemodify(filepath, "<cmd>h")
	vim.fn.jobstart({ "nemo", dir }, { detach = true })
end

-- RUN PYTHON ON THE RIGHT
keymap.set(
	"n",
	"<leader>pp",
	[[<cmd>lua OpenTmuxPaneAndRunPython()<CR>]],
	{ noremap = true, silent = true, desc = "Open tmux vertical split & run Python (py312)" }
)

function OpenTmuxPaneAndRunPython()
	local file = vim.fn.expand("%:p") -- Get full path of current file
	-- Create a new tmux split below
	vim.fn.system("tmux split-window -h")
	-- Send the commands to the new pane and keep it open
	vim.fn.system("tmux send-keys 'source ~/.venvs/py312/bin/activate && python " .. file .. " ; exec $SHELL' Enter")
	-- Switch focus to the newly created pane
	vim.fn.system("tmux select-pane -D")
end

-- INSERT IGNORE FOR PYRIGHT AT EOL
keymap.set("n", "<leader>li", function()
	local line = vim.fn.getline(".")
	vim.fn.setline(vim.fn.line("."), line .. "    # pyright: ignore")
end, { noremap = true, silent = true, desc = "Append '# pyright: ignore' at the end of the line" })

-- SEARCH SELECTION IN SCHOLAR
keymap.set(
	"n",
	"<leader>gs",
	[[:<C-u>lua local query = vim.fn.getreg('"'):gsub(" ", "%%20"); vim.fn.system("xdg-open 'https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=" .. query .. "&btnG='")<CR>]],
	{ noremap = true, silent = true, desc = "Google Scholar yanked text" }
)
