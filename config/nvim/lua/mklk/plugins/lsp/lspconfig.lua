return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig") -- import lspconfig plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp") -- import cmp-nvim-lsp plugin
		local keymap = vim.keymap -- for conciseness

		-- Create the autocmd for LSP keybindings
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "gh", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>sr", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>dd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show workspace diagnostics"
				keymap.set("n", "<leader>dr", "<cmd>Telescope diagnostics<CR>", opts) -- show diagnostics for workspace

				opts.desc = "Diagnostics Line show"
				keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "<leader>dp", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)
				keymap.set("n", "<leader>K", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "<leader>dn", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)
				keymap.set("n", "<leader>J", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)

				-- Yank diagnostics message
				keymap.set("n", "<leader>dy", function()
					local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
					if #diagnostics == 0 then
						print("No diagnostics on this line.")
						return
					end
					local messages = {}
					for _, diag in ipairs(diagnostics) do
						table.insert(messages, diag.message)
					end
					local result = table.concat(messages, "\n")
					vim.fn.setreg("+", result) -- Yank to clipboard
					print("Copied diagnostics to clipboard!")
				end, { desc = "Yank diagnostics message" })

				-- Toggle diagnostics visibility
				keymap.set(
					"n",
					"<leader>dt",
					":lua ToggleDiagnostics()<CR>",
					{ noremap = true, silent = true, desc = "Toggle diagnostics visibility" }
				)
				local diagnostics_visible = true
				function ToggleDiagnostics()
					diagnostics_visible = not diagnostics_visible
					if diagnostics_visible then
						vim.diagnostic.enable(true) -- Enable diagnostics for the current buffer
						print("Diagnostics enabled")
					else
						vim.diagnostic.enable(false) -- Disable diagnostics for the current buffer
						print("Diagnostics disabled")
					end
				end

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>lr", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Update diagnostic signs in the sign column using the new API
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
		}

		vim.diagnostic.config({
			signs = {
				text = signs,
			},
		})

		-- #### LSP SETUP - DIRECT METHOD #### --
		-- Define the global toggle diagnostics function
		_G.ToggleDiagnostics = function()
			local diagnostics_visible = vim.g.diagnostics_visible or true
			vim.g.diagnostics_visible = not diagnostics_visible
			if vim.g.diagnostics_visible then
				vim.diagnostic.enable(true) -- Enable diagnostics
				print("Diagnostics enabled")
			else
				vim.diagnostic.enable(false) -- Disable diagnostics
				print("Diagnostics disabled")
			end
		end

		-- Define custom root dir detection
		local function get_python_root(startpath)
			local git_dir = vim.fs.find({ ".git" }, { path = startpath, upward = true })[1]
			local project_dir = vim.fs.find(
				{ "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" },
				{ path = startpath, upward = true }
			)[1]
			return vim.fs.dirname(git_dir or project_dir or startpath)
		end

		-- Pyright
		lspconfig.pyright.setup({
			capabilities = capabilities,
			root_dir = get_python_root,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		-- -- Basedpyright
		-- lspconfig.basedpyright.setup({
		-- 	capabilities = capabilities,
		-- 	root_dir = get_python_root,
		-- 	settings = {
		-- 		python = {
		-- 			analysis = {
		-- 				autoSearchPaths = true,
		-- 				useLibraryCodeForTypes = true,
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- Ruff
		-- lspconfig.ruff.setup({
		-- 		capabilities = capabilities,
		-- 		on_attach = function(client, bufnr)
		-- 			-- disable all positional features
		-- 			client.server_capabilities.definitionProvider = false
		-- 			client.server_capabilities.hoverProvider = false
		-- 			client.server_capabilities.referencesProvider = false
		-- 			client.server_capabilities.renameProvider = false
		-- 			client.server_capabilities.documentFormattingProvider = false
		-- 			client.server_capabilities.codeActionProvider = false
		-- 		end,
		-- 		-- Optional settings - you can adjust these based on your preferences
		-- 		settings = {
		-- 			-- You can add specific Ruff settings here if needed
		-- 		},
		-- 	})
		-- })

		-- Rust Analyzer
		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
			filetypes = { "rust" },
			root_dir = function(fname)
				local util = require("lspconfig.util")

				-- First try to find Cargo.toml
				local cargo_root = util.root_pattern("Cargo.toml")(fname)
				if cargo_root then
					return cargo_root
				end

				-- Then try to find .git using vim.fs (modern Neovim way)
				local git_dir = vim.fs.find(".git", { path = fname, upward = true })[1]
				if git_dir then
					return vim.fs.dirname(git_dir)
				end

				-- Fallback to current working directory (scratch file)
				return vim.fn.getcwd()
			end,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					inlayHints = {
						lifetimeElisionHints = {
							enable = true,
							useParameterNames = true,
						},
					},
				},
			},
		})

		-- Svelte
		lspconfig.svelte.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						-- Here use ctx.match instead of ctx.file
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
		})

		-- TypeScript
		lspconfig.ts_ls.setup({ -- Note: changed from ts_ls to tsserver which is the correct server name
			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern("tsconfig.json")(fname)
					or require("lspconfig.util").root_pattern("package.json", "jsconfig.json", ".git")(fname)
			end,
			single_file_support = true,
			on_attach = function(client, bufnr)
				-- Disable built-in formatting in favor of external formatters like Prettier
				client.server_capabilities.documentFormattingProvider = false
			end,
		})

		-- ESLint
		lspconfig.eslint.setup({
			capabilities = capabilities,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll", -- Auto-fix on save
				})
			end,
		})

		-- Lua
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		-- Graphql
		-- lspconfig.graphql.setup({
		--     capabilities = capabilities,
		--     filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		--   })

		-- Emmet
		-- lspconfig.emmet_ls.setup({
		--     capabilities = capabilities,
		--     filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		--   })
		-- end,
	end,
}
