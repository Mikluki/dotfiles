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

		-- You can add more markdown snippets here
	},

	tex = {
		ls.add_snippets("tex", {
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
		}),
	},
	-- You can add snippets for other file types
	-- lua = { ... },
	-- python = { ... },
}

-- Register all snippets
for filetype, filetype_snippets in pairs(snippets) do
	ls.add_snippets(filetype, filetype_snippets)
end

-- Function to insert the figure snippet
local function insert_figure_snippet()
	-- Check if we're in a markdown file
	local ft = vim.bo.filetype
	if ft == "markdown" then
		-- Expand the 'fig' snippet
		ls.snip_expand(snippets.markdown[1])
	else
		print("figure snippet is only available in markdown files")
	end
end

-- Function to insert the two figures snippet
local function insert_two_figures_snippet()
	-- Check if we're in a markdown file
	local ft = vim.bo.filetype
	if ft == "markdown" then
		-- Expand the 'fig' snippet
		ls.snip_expand(snippets.markdown[2])
	else
		print("Two figures snippet is only available in markdown files")
	end
end

-- Define the keymaps directly in this file
vim.keymap.set("n", "<leader>mff", function()
	insert_figure_snippet()
end, { desc = "Insert markdown figure snippet", noremap = true, silent = true })

vim.keymap.set("n", "<leader>mf2", function()
	insert_two_figures_snippet()
end, { desc = "Insert two figures side by side", noremap = true, silent = true })

-- Return the module with the insert functions
return {
	snippets = snippets,
	insert_figure_snippet = insert_figure_snippet,
	insert_two_figures_snippet = insert_two_figures_snippet,
}
