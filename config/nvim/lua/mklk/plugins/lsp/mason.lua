return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- mason_lspconfig.setup({
		-- 	-- list of servers for mason to install
		-- 	ensure_installed = {
		-- 		"html",
		-- 		"lua_ls",
		-- 		"pyright",
		-- 		-- "ruff",
		-- 		"cssls",
		-- 		"eslint", -- ESLint LSP for linting
		-- 		"ts_ls", -- TypeScript/JavaScript LSP
		-- 		"rust_analyzer",
		-- 		-- "pylint",
		-- 		-- "tailwindcss",
		-- 		-- "svelte",
		-- 		-- "graphql",
		-- 		-- "emmet_ls",
		-- 		-- "prismals",
		-- 	},
		-- 	automatic_installation = false,
		-- 	automatic_setup = false,
		-- })

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- Prettier formatter
				"stylua", -- Lua formatter
				"isort", -- Python formatter
				"black", -- Python formatter
				"eslint_d", -- Faster ESLint daemon
				-- "ruff", -- ruff is installed as a tool
			},
		})
	end,
}
