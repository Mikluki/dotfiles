-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

---------------------------
-- ### GENERAL KEYMAPS ###--

-- use jj tofexit insert mode
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<ESC>", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')
--
-- Paste without overwrite
keymap.set("v", "p", "P", opts)
-- Undo quicker
keymap.set("n", "U", ":redo<CR>", opts)

-- ### NAVIGATION ###
-- keymap.set("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Explorer" })
keymap.set("n", "<leader>w", "<cmd>wa<CR>", { desc = "Save all" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close buffer" })
keymap.set("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Close all" })
keymap.set("n", "<leader>X", "<cmd>bufdo bd!<CR>", { desc = "Close all" })

-- ### WINDOW MANAGEMENT ###
-- ## SPLITS ##
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>sd", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

-- Resize splits using arrow keys + Control
keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase height" })
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease height" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })

-- ## TABS ##
keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
-- keymap.set("n", "<leader>x", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- keymap.set("n", "<leader>td", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

keymap.set("n", "<M-k>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<M-j>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab

-- ## REPLACE SELECTION ##
keymap.set("v", "<C-r>", '"hy:%s/<C-r>h//gc<left><left><left>', opts)

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

keymap.set("o", "l", "$", opts)
keymap.set("o", "h", "^", opts)

-- ### CENTERING CONTENT ###

-- centering jumps
keymap.set("v", "gg", "ggzz", opts)
keymap.set("n", "gg", "ggzz", opts)
-- When you search, center the result and open any folds
keymap.set("n", "n", "nzzzv", opts)
-- When you search backwards, center the result and open any folds
keymap.set("n", "N", "Nzzzv", opts)

-- Keep the cursor in the same place when joining or breaking lines
keymap.set("n", "J", "mzJ`z", opts)
keymap.set("n", "K", "mzi<CR><Esc>`z", opts)

-- ### CUSTOM UTIL ###
-- Toggle line wrapping
keymap.set("n", "<leader>tw", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrapping " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle line wrapping" })

-- Yank path of current file
keymap.set("n", "<leader>yp", [[:let @+ = expand('%:p')<CR>]], { noremap = true, silent = true })

-- insert ignore for pyright at EOL
keymap.set("n", "<leader>li", function()
	local line = vim.fn.getline(".")
	vim.fn.setline(vim.fn.line("."), line .. "    # pyright: ignore")
end, { noremap = true, silent = true, desc = "Append '# pyright: ignore' at the end of the line" })

-- search Selection in Scholar
keymap.set(
	"n",
	"<leader>gs",
	[[:<C-u>lua local query = vim.fn.getreg('"'):gsub(" ", "%%20"); vim.fn.system("xdg-open 'https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=" .. query .. "&btnG='")<CR>]],
	opts
)
