local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Define the snippets
local snippets = {
	markdown = {
		-- figure with width attribute
		s("fig", {
			t("!["),
			i(1, "alt text"),
			t("]("),
			i(2, "pics/"),
			t(")"),
			t('{ width="'),
			i(3, "400"),
			t("px #fig:label}"),
		}),

		-- Two figures side by side
		s("fig2", {
			t("::: {#fig:subfigs layout-ncol=2}"),
			t({ "", "" }),
			t("!["),
			i(1, "Left figure"),
			t("]("),
			i(2, "pics/"),
			t("){width="),
			i(3, "380"),
			t("px #fig:left}"),
			t({ "", "" }),
			t("!["),
			i(4, "Right figure"),
			t("]("),
			i(5, "pics/"),
			t("){width="),
			i(6, "380"),
			t("px #fig:right}"),
			t({ "", "" }),
			t(":::"),
		}),
	},

	tex = {
		s("header_russian_XeLaTeX", {
			t({
				"% Change figure caption label to Russian",
				"\\renewcommand{\\figurename}{Рисунок}",
				"",
				"% Direct page margin settings",
				"\\usepackage[left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm]{geometry}",
				"",
				"% Direct line spacing setting",
				"\\renewcommand{\\baselinestretch}{1.5}",
				"\\normalsize",
			}),
		}),
		s("header_minimal", {
			t({
				"\\documentclass{article}",
				"\\usepackage{amsmath} % for align, gather, etc.",
				"\\begin{document}",
				"\\end{document}",
			}),
		}),
	},

	python = {
		s("pyignore", {
			t(" # pyright: ignore"),
		}),
	},

	-- Define snippets properly for all filetypes
	-- all = {	},
}

-- Register all snippets
for filetype, filetype_snippets in pairs(snippets) do
	ls.add_snippets(filetype, filetype_snippets)
end

-- Function to insert pyright ignore
vim.keymap.set("n", "<leader>li", function()
	local line = vim.fn.getline(".")
	if not line:find("# pyright: ignore", 1, true) then
		vim.fn.setline(".", line .. "  # pyright: ignore")
	end
end, { noremap = true, silent = true, desc = "Append '# pyright: ignore' to end of current line" })

-- Function to insert the figure snippet
local function insert_figure_snippet()
	local ft = vim.bo.filetype
	if ft == "markdown" then
		ls.snip_expand(snippets.markdown[1])
	else
		print("Snippet: figure is only for md files")
	end
end

-- Function to insert the two figures snippet
local function insert_two_figures_snippet()
	local ft = vim.bo.filetype
	if ft == "markdown" then
		ls.snip_expand(snippets.markdown[2])
	else
		print("Snippet: two figures is only for md files")
	end
end

-- Define the keymaps
vim.keymap.set("n", "<leader>mff", function()
	insert_figure_snippet()
end, { desc = "Insert markdown figure snippet", noremap = true, silent = true })

vim.keymap.set("n", "<leader>mf2", function()
	insert_two_figures_snippet()
end, { desc = "Insert two figures side by side", noremap = true, silent = true })

-- ### EOL custom functions ###
-- EOL do not write lets discuss
local function insert_dono()
	local text = "Do not write code yet, lets discuss."
	local current_line = vim.fn.getline(".")
	vim.fn.setline(".", current_line .. text)
end

vim.keymap.set({ "n" }, "<leader>ld", insert_dono, {
	desc = "Insert 'Do not write code lets discuss'",
	noremap = true,
	silent = true,
})

-- EOL do not change code I will edit myself give short snippets of target code
local function insert_write_piece()
	local text = "Do not change code. Give full snippets of target areas. I will edit myself"
	local current_line = vim.fn.getline(".")
	vim.fn.setline(".", current_line .. text)
end

vim.keymap.set({ "n" }, "<leader>ls", insert_write_piece, {
	desc = "Insert 'Do not write code lets discuss'",
	noremap = true,
	silent = true,
})

-- Return the module with the insert functions
return {
	snippets = snippets,
	insert_figure_snippet = insert_figure_snippet,
	insert_two_figures_snippet = insert_two_figures_snippet,
	insert_dono = insert_dono,
}
