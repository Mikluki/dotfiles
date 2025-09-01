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
-- next item
keymap.set("n", "<leader>jj", "<cmd>cnext<CR>", { desc = "Quickfix Next" })
keymap.set("n", "<leader>cn", "<cmd>cnext<CR>", { desc = "Quickfix Next" })
-- prev item
keymap.set("n", "<leader>kk", "<cmd>cprev<CR>", { desc = "Quickfix Prev" })
keymap.set("n", "<leader>cb", "<cmd>cprev<CR>", { desc = "Quickfix Prev" })
-- first item
keymap.set("n", "<leader>cF", "<cmd>cfirst<CR>", { desc = "Quickfix First" })
-- last item
keymap.set("n", "<leader>cl", "<cmd>clast<CR>", { desc = "Quickfix Last" })
-- cdo
keymap.set("n", "<leader>cD", ":cdo ", { desc = "Quickfix Do" })
-- open & close
keymap.set("n", "<leader>co", "<cmd>copen<CR>", { desc = "Quickfix Open" })
keymap.set("n", "<leader>cq", "<cmd>cclose<CR>", { desc = "Quickfix Close" })

-- ### SAVE & CLOSE ###
-- keymap.set("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Explorer" })
keymap.set("n", "<leader>w", "<cmd>wa<CR>", { desc = "Save all" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close buffer" })
keymap.set("n", "<leader>W", "<cmd>wa|qa<CR>", { desc = "Save all & Close all" })
keymap.set("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Close all" })
keymap.set("n", "<leader>X", "<cmd>bufdo bd!<CR>", { desc = "Delete all buffers" })

-- ### SPLIT MANAGEMENT ###
-- ## SPLITS ##
keymap.set("n", "<leader>sn", "<cmd>vnew<CR>", { desc = "Empty split on the right" }) -- split window vertically
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>sd", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
-- keymap.set("n", "<leader>sd", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

-- Resize splits using arrow keys + Control
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- DIFF SPLIT VERTICAL
vim.keymap.set("n", "<leader>dv", function()
	local cur_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_tabpage_list_wins(0)

	-- Sort windows left-to-right by their column position
	table.sort(wins, function(a, b)
		local a_pos = vim.api.nvim_win_get_position(a)[2]
		local b_pos = vim.api.nvim_win_get_position(b)[2]
		return a_pos < b_pos
	end)

	if #wins < 2 then
		print("Need at least 2 vertical splits.")
		return
	end

	-- Only apply to the two left-most windows
	vim.api.nvim_set_current_win(wins[1])
	vim.cmd("diffthis")
	vim.api.nvim_set_current_win(wins[2])
	vim.cmd("diffthis")

	-- Restore the original window focus
	vim.api.nvim_set_current_win(cur_win)
end, { desc = "Diff left and right vertical splits", noremap = true, silent = true })

vim.keymap.set("n", "<leader>do", function()
	local cur_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_tabpage_list_wins(0)

	for _, win in ipairs(wins) do
		vim.api.nvim_set_current_win(win)
		vim.cmd("diffoff")
	end

	vim.api.nvim_set_current_win(cur_win)
end, { desc = "Turn off diff in all splits", noremap = true, silent = true })

-- ### TAB MANAGEMENT ###
keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- keymap.set("n", "<leader>td", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

-- keymap.set("n", "<M-k>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
-- keymap.set("n", "<M-j>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- Keymaps to jump to tabs
-- vim.api.nvim_set_keymap("n", "<leader>1", "1gt", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>2", "2gt", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>3", "3gt", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>4", "3gt", { noremap = true, silent = true })

-- ### BUFFERS & NAVIAGTION ###
local function safe_buffer_delete()
	-- Close Trouble symbols if it's open
	vim.cmd("Trouble symbols close")
	-- Then delete the buffer
	vim.cmd("bd")
end

keymap.set("n", "<leader>db", safe_buffer_delete, { desc = "Buffer delete" })
keymap.set("n", "<leader>sx", safe_buffer_delete, { desc = "Buffer delete" })

keymap.set("n", "<M-k>", "<cmd>bnext<CR>", { desc = "Buffer next" }) --  go to next tab
keymap.set("n", "<M-j>", "<cmd>bprev<CR>", { desc = "Buffer previous" }) --  go to previous tab

vim.keymap.set("n", "<M-f>", "<C-^>", { desc = "Switch to previous buffer" })
vim.keymap.set("n", "<leader>ss", "<C-^>", { desc = "Switch to previous buffer" })

vim.keymap.set("n", "<leader>bt", function()
	local val = vim.o.showtabline == 0 and 2 or 0
	vim.o.showtabline = val
end, { desc = "Toggle BufferTabline" })

-- ## Close all buffers except current
vim.keymap.set("n", "<leader>bB", ":%bd|e#|bd#<CR>", { desc = "Close all buffers except current" })

-- ## Jump to N-th buffer (listed buffers only)
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		local buffers = vim.fn.getbufinfo({ buflisted = 1 })
		if buffers[i] then
			vim.api.nvim_set_current_buf(buffers[i].bufnr)
		end
	end, { noremap = true, silent = true })
end

-- ## REPLACE SELECTION ##
-- replace in current buffer
keymap.set("v", "<leader>s", function()
	-- Yank selection
	vim.cmd('normal! "hy')
	-- Get yanked text
	local pattern = vim.fn.getreg("h")
	-- Construct command and feed it as keystrokes
	local cmd = string.format(":%%s/\\V%s//gc", pattern)
	-- Feed the command and position cursor before the replacement part
	vim.fn.feedkeys(cmd .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3))
end, { noremap = true, silent = true, desc = "substitute selection" })

-- replace in all buffers
keymap.set("v", "<leader>bs", function()
	-- Yank selection
	vim.cmd('normal! "hy')
	-- Get yanked text
	local pattern = vim.fn.getreg("h")
	-- Construct command and feed it as keystrokes so user can type replacement
	local cmd = string.format(":bufdo %%s/\\V%s//gc", pattern)
	-- Feed the command and position cursor before the replacement part
	vim.fn.feedkeys(cmd .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3))
end, { noremap = true, silent = true, desc = "Substitute selection in all buffers" })

-- ## MACROS ##
-- Run macro bound to q with Q
keymap.set("n", "Q", "@q", opts)

-- -- ## PAGE NAVIAGTION ##
-- keymap.set("v", "j", "gj", opts)
-- keymap.set("v", "k", "gk", opts)
-- keymap.set("n", "j", "gj", opts)
-- keymap.set("n", "k", "gk", opts)

-- ## EOF SHORTCUTS ##
keymap.set({ "n", "v", "o" }, "L", "$", opts)
keymap.set({ "n", "v", "o" }, "H", "^", opts)

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
keymap.set("n", "K", "i<cr><esc>k$", { noremap = true, silent = true, desc = "Break line" })
keymap.set("n", "J", "mzgJ`z", { noremap = true, silent = true, desc = "Join lines" })

-- #######################
-- ##### CUSTOM UTIL #####
-- #######################

-- ### FILES & BUFFERS ###
-- Delete current file in buffer with confirmation and clse buffer
keymap.set(
	"n",
	"<Leader>D",
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
	"<leader>md",
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
keymap.set(
	{ "v", "n" },
	"<leader>mf",
	"<cmd>lua MdFormatLatex()<CR>",
	{ noremap = true, silent = true, desc = "Format MD math to Tex math" }
)

---===================================---
-- COMPILE LATEX TO PDF using pdflatex in tmux pane
function TexCompilePdflatex()
	-- Check if current file is a .tex file
	local current_file = vim.fn.expand("%")
	if not string.match(current_file, "%.tex$") then
		print("Error: Current file is not a .tex file")
		return
	end

	local input_file = vim.fn.expand("%:p") -- Get full path of the current file
	local input_dir = vim.fn.expand("%:p:h") -- Get directory of the current file
	local filename = vim.fn.expand("%:t") -- Get filename with extension

	-- Check if we're in a tmux session
	local tmux_check = vim.fn.system("tmux display-message 2>/dev/null")
	if vim.v.shell_error ~= 0 then
		print("Error: Not in a tmux session. Please run vim inside tmux to use this function.")
		return
	end

	-- Check if right pane exists by counting panes
	local pane_count = vim.fn.system("tmux list-panes | wc -l")
	if vim.v.shell_error ~= 0 then
		print("Error: Failed to list tmux panes")
		return
	end

	-- Get current pane index before doing anything
	local current_pane = vim.fn.system("tmux display-message -p '#{pane_index}'")
	if vim.v.shell_error ~= 0 then
		print("Error: Failed to get current pane index")
		return
	end
	current_pane = current_pane:gsub("%s+", "") -- trim whitespace

	local right_pane_exists = tonumber(pane_count) > 1

	-- Create right pane if it doesn't exist
	if not right_pane_exists then
		vim.fn.system("tmux split-window -h")
		if vim.v.shell_error ~= 0 then
			print("Error: Failed to create tmux pane")
			return
		end
		-- Switch back to the original pane
		vim.fn.system("tmux select-pane -t " .. current_pane)
	end

	-- Send commands to right pane without switching focus
	local rightmost_pane = vim.fn.system("tmux list-panes -F '#{pane_index}' | tail -1")
	if vim.v.shell_error ~= 0 then
		print("Error: Failed to get rightmost pane")
		return
	end

	rightmost_pane = rightmost_pane:gsub("%s+", "") -- trim whitespace

	-- Send commands to the specific pane without switching focus
	vim.fn.system("tmux send-keys -t " .. rightmost_pane .. " 'cd " .. vim.fn.shellescape(input_dir) .. "' Enter")
	vim.fn.system("tmux send-keys -t " .. rightmost_pane .. " 'pdflatex " .. vim.fn.shellescape(filename) .. "' Enter")

	print("Running pdflatex on " .. filename .. " in tmux pane...")
end

-- -- Keymap for LaTeX compilation
-- vim.keymap.set("n", "<leader>lcp", TexCompilePdflatex, {
-- 	desc = "Compile LaTeX to PDF using pdflatex in tmux pane",
-- })

-- Create user commands to make functions accessible from : menu
vim.api.nvim_create_user_command("TexCompilePdflatex", TexCompilePdflatex, {
	desc = "Compile LaTeX to PDF using pdflatex (single run)",
})

---===================================---
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
	{ noremap = true, silent = true, desc = "Open md or tex with sioyek" }
)

-- OPEN IN BRAVE-BROWSER
function _G.open_url_in_brave()
	-- Get the URL under cursor
	local url = vim.fn.expand("<cfile>")

	-- Check if URL has a protocol, add https if missing
	if not string.match(url, "^https?://") then
		url = "https://" .. url
	end

	-- Command to open URL in Brave (adjust path based on your OS)
	local cmd = ""
	if vim.fn.has("unix") == 1 then
		cmd = 'brave-browser "' .. url .. '"'
	elseif vim.fn.has("mac") == 1 then
		cmd = 'open -a "Brave Browser" "' .. url .. '"'
	end

	-- Execute the command
	vim.fn.system(cmd)
	-- print("Opening " .. url .. " in Brave")
end

-- Map the shortcut to <leader>o (you can change this to whatever you prefer)
vim.api.nvim_set_keymap("n", "<leader>ob", ":lua open_url_in_brave()<CR>", { noremap = true, silent = true })

-- TOGGLE LINE WRAPPING
keymap.set("n", "<leader>wt", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrapping " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle wrapping" })

-- YAZI like mappings
local mappings = {
	{ lhs = "<leader>cf", expr = "%:t", desc = "Yank filename of the current file" },
	{ lhs = "<leader>cc", expr = "%:p", desc = "Yank path of the current file" },
	{ lhs = "<leader>cr", expr = "%", desc = "Yank relative path of the current file" },
	{ lhs = "<leader>cd", expr = "%:p:h", desc = "Yank path of the current dir" },
}

for _, map in ipairs(mappings) do
	keymap.set(
		"n",
		map.lhs,
		[[:let @+ = expand("]] .. map.expr .. [[")<CR>]],
		{ noremap = true, silent = true, desc = map.desc }
	)
end

-- OPEN NEMO AT CURRENT FILE
keymap.set(
	"n",
	"<leader>on",
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

-- SEARCH SELECTION IN SCHOLAR
keymap.set(
	"n",
	"<leader>os",
	[[:<C-u>lua local query = vim.fn.getreg('"'):gsub(" ", "%%20"); vim.fn.system("xdg-open 'https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=" .. query .. "&btnG='")<CR>]],
	{ noremap = true, silent = true, desc = "Open Scholar yanked text" }
)
