return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
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

		mason_lspconfig.setup({
			-- automatic_installation = true,
			-- list of servers for mason to install
			ensure_installed = {
				"html",
				"lua_ls",
				"pyright",
				-- "pylint",
				-- "ruff",
				"cssls",
				"eslint", -- ESLint LSP for linting
				"ts_ls", -- TypeScript/JavaScript LSP
				-- "tailwindcss",
				-- "svelte",
				-- "graphql",
				-- "emmet_ls",
				-- "prismals",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- Prettier formatter
				"stylua", -- Lua formatter
				"isort", -- Python formatter
				"black", -- Python formatter
				"eslint_d", -- Faster ESLint daemon
			},
		})
	end,
}
