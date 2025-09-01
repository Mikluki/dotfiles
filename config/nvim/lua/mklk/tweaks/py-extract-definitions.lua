-- Python Definition Extractor Module
local M = {}

-- The main extraction function using regex
local function extract_definitions(include_docstrings)
	-- Create a new buffer in a vertical split
	vim.cmd("vnew")
	vim.bo.buftype = "nofile"
	vim.bo.filetype = "python"
	vim.bo.swapfile = false

	-- Set buffer name based on extraction mode
	if include_docstrings then
		vim.api.nvim_buf_set_name(0, "Python Definitions with Docstrings")
	else
		vim.api.nvim_buf_set_name(0, "Python Definitions")
	end

	local source_bufnr = vim.fn.bufnr("#")
	local lines = vim.api.nvim_buf_get_lines(source_bufnr, 0, -1, false)
	local result = {}
	local i = 1

	while i <= #lines do
		local line = lines[i]

		-- Check for class or def definition
		if line:match("^%s*class%s+") or line:match("^%s*def%s+") then
			local def_type = line:match("^%s*class") and "class" or "def"
			local indent_level = #(line:match("^%s*") or "")
			table.insert(result, line)
			i = i + 1

			-- Handle multi-line definitions (like with decorators or line continuations)
			local paren_count = select(2, line:gsub("%(", "")) - select(2, line:gsub("%)", ""))
			while i <= #lines and (paren_count > 0 or not lines[i]:match(":$")) do
				local next_line = lines[i]
				table.insert(result, next_line)
				paren_count = paren_count + select(2, next_line:gsub("%(", "")) - select(2, next_line:gsub("%)", ""))
				i = i + 1
				if next_line:match(":$") and paren_count <= 0 then
					break
				end
			end

			-- Look for docstring if enabled
			if include_docstrings then
				local j = i
				-- Skip blank lines
				while j <= #lines and lines[j]:match("^%s*$") do
					j = j + 1
				end

				-- Check for docstring
				if j <= #lines then
					local potential_docstring = lines[j]
					local doc_indent = #(potential_docstring:match("^%s*") or "")

					-- Check if next line has more indentation and starts with a quote
					-- Important: For class methods, we need exactly one indent level more for the docstring
					-- For the class itself, we need the docstring to be at class body indent level
					local expected_indent = indent_level + 4 -- Assuming 4 spaces per indent level

					-- Only capture the docstring if it's at the correct indent level relative to the definition
					if
						doc_indent == expected_indent
						and (potential_docstring:match('^%s*"""') or potential_docstring:match("^%s*'''"))
					then
						local docstring_type = potential_docstring:match('^%s*"""') and '"""' or "'''"
						table.insert(result, potential_docstring)

						-- If docstring is single-line, we're done
						if potential_docstring:match(docstring_type .. ".*" .. docstring_type .. "%s*$") then
							i = j + 1
						else
							-- Handle multi-line docstring
							i = j + 1
							while i <= #lines do
								local docline = lines[i]
								table.insert(result, docline)
								i = i + 1
								-- Stop if we reach the end of docstring
								if docline:match(docstring_type) then
									break
								end
							end
						end
					end
				end
			end

			table.insert(result, "") -- Add blank line
		else
			i = i + 1
		end
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
	vim.cmd("normal! gg") -- Move cursor to top of file
end

-- Try to use treesitter if available
local function try_treesitter_extract(include_docstrings)
	-- Check if treesitter is available
	if not pcall(require, "nvim-treesitter") then
		return extract_definitions(include_docstrings)
	end

	-- Ensure Python parser is installed
	local parsers = require("nvim-treesitter.parsers")
	if not parsers.has_parser("python") then
		vim.notify("Python parser not installed. Using fallback parser.", vim.log.levels.WARN)
		return extract_definitions(include_docstrings)
	end

	-- Create new buffer
	vim.cmd("vnew")
	vim.bo.buftype = "nofile"
	vim.bo.filetype = "python"

	-- Set buffer name based on extraction mode
	if include_docstrings then
		vim.api.nvim_buf_set_name(0, "Python Definitions with Docstrings (TS)")
	else
		vim.api.nvim_buf_set_name(0, "Python Definitions (TS)")
	end

	-- Get source buffer and its filetype
	local source_bufnr = vim.fn.bufnr("#")
	if vim.bo[source_bufnr].filetype ~= "python" then
		vim.notify("Current buffer is not a Python file", vim.log.levels.ERROR)
		return
	end

	-- Get source code
	local source_lines = vim.api.nvim_buf_get_lines(source_bufnr, 0, -1, false)

	-- Get the root tree
	local parser = vim.treesitter.get_parser(source_bufnr, "python")
	local tree = parser:parse()[1]
	local root = tree:root()

	local result = {}

	-- Two separate queries for class definitions and function definitions
	-- This helps us avoid mixing up docstrings from class methods
	local class_query_str = [[
    (class_definition
      name: (identifier) @class_name
      body: (block 
             . (expression_statement 
                 (string) @class_docstring)?)) @class_def
  ]]

	local function_query_str = [[
    (function_definition
      name: (identifier) @function_name
      body: (block 
             . (expression_statement 
                 (string) @function_docstring)?)) @function_def
  ]]

	local class_query = vim.treesitter.query.parse("python", class_query_str)
	local function_query = vim.treesitter.query.parse("python", function_query_str)

	-- Helper to get node text
	local function get_node_text(node)
		local start_row, start_col, end_row, end_col = node:range()
		local result = {}

		-- For a single line node
		if start_row == end_row then
			return string.sub(source_lines[start_row + 1], start_col + 1, end_col)
		end

		-- For the first line
		table.insert(result, string.sub(source_lines[start_row + 1], start_col + 1))

		-- For middle lines
		for i = start_row + 1, end_row - 1 do
			if i + 1 <= #source_lines then
				table.insert(result, source_lines[i + 1])
			end
		end

		-- For the last line
		if end_row + 1 <= #source_lines then
			table.insert(result, string.sub(source_lines[end_row + 1], 1, end_col))
		end

		return table.concat(result, "\n")
	end

	-- Helper to get definition text
	local function get_definition_text(node)
		local start_row, start_col = node:range()
		local has_colon = false
		local def_lines = {}
		local i = start_row

		-- Keep collecting lines until we find line ending with ":"
		while i < #source_lines and not has_colon do
			local line = ""
			if i == start_row then
				line = string.sub(source_lines[i + 1], start_col + 1)
			else
				line = source_lines[i + 1]
			end

			table.insert(def_lines, line)

			if line:match(":$") then
				has_colon = true
			end

			i = i + 1
		end

		return def_lines
	end

	-- First process class definitions
	for id, node in class_query:iter_captures(root, source_bufnr, 0, -1) do
		local capture_name = class_query.captures[id]

		if capture_name == "class_def" then
			-- Get class definition text
			local def_lines = get_definition_text(node)
			for _, line in ipairs(def_lines) do
				table.insert(result, line)
			end

			-- Process class docstring if enabled
			if include_docstrings then
				for doc_id, doc_node in class_query:iter_captures(node, source_bufnr) do
					local doc_capture = class_query.captures[doc_id]
					if doc_capture == "class_docstring" then
						local docstring = get_node_text(doc_node)
						for _, line in ipairs(vim.split(docstring, "\n")) do
							table.insert(result, line)
						end
					end
				end
			end

			table.insert(result, "") -- Add blank line
		end
	end

	-- Then process function definitions that are at the root level
	for id, node in function_query:iter_captures(root, source_bufnr, 0, -1) do
		local capture_name = function_query.captures[id]

		if capture_name == "function_def" then
			-- Check if this function is a method (inside a class) or a standalone function
			local parent = node:parent()
			if parent and parent:type() ~= "block" then
				-- Skip methods inside classes for now
				goto continue
			end

			-- Get function definition text
			local def_lines = get_definition_text(node)
			for _, line in ipairs(def_lines) do
				table.insert(result, line)
			end

			-- Process function docstring if enabled
			if include_docstrings then
				for doc_id, doc_node in function_query:iter_captures(node, source_bufnr) do
					local doc_capture = function_query.captures[doc_id]
					if doc_capture == "function_docstring" then
						local docstring = get_node_text(doc_node)
						for _, line in ipairs(vim.split(docstring, "\n")) do
							table.insert(result, line)
						end
					end
				end
			end

			table.insert(result, "") -- Add blank line

			::continue::
		end
	end

	-- Now process methods inside classes
	for id, node in function_query:iter_captures(root, source_bufnr, 0, -1) do
		local capture_name = function_query.captures[id]

		if capture_name == "function_def" then
			-- Only include methods inside classes
			local parent = node:parent()
			if
				not parent
				or parent:type() ~= "block"
				or not parent:parent()
				or parent:parent():type() ~= "class_definition"
			then
				-- Skip standalone functions
				goto continue
			end

			-- Get method definition text
			local def_lines = get_definition_text(node)
			for _, line in ipairs(def_lines) do
				table.insert(result, line)
			end

			-- Process method docstring if enabled
			if include_docstrings then
				for doc_id, doc_node in function_query:iter_captures(node, source_bufnr) do
					local doc_capture = function_query.captures[doc_id]
					if doc_capture == "function_docstring" then
						local docstring = get_node_text(doc_node)
						for _, line in ipairs(vim.split(docstring, "\n")) do
							table.insert(result, line)
						end
					end
				end
			end

			table.insert(result, "") -- Add blank line

			::continue::
		end
	end

	-- Set content in the new buffer
	vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
	vim.cmd("normal! gg") -- Move cursor to top of file
end

-- Extract function that determines which method to use
local function extract(include_docstrings)
	-- Validate current buffer is Python
	if vim.bo.filetype ~= "python" then
		vim.notify("Current buffer is not a Python file", vim.log.levels.ERROR)
		return
	end

	-- Try to use treesitter if available, otherwise use regex-based extraction
	local status, err = pcall(function()
		try_treesitter_extract(include_docstrings)
	end)

	if not status then
		vim.notify(
			"Treesitter extraction failed: " .. tostring(err) .. "\nUsing regex-based extraction",
			vim.log.levels.WARN
		)
		extract_definitions(include_docstrings)
	end
end

-- Setup function
function M.setup(opts)
	opts = opts or {}

	-- Define commands for both modes
	vim.api.nvim_create_user_command("ExtractPyDefs", function()
		extract(false) -- Definitions only
	end, {})

	vim.api.nvim_create_user_command("ExtractPyDefsWithDocs", function()
		extract(true) -- Definitions with docstrings
	end, {})

	-- Set up keymaps with defaults
	local def_keymap = opts.def_keymap or "<leader>ped"
	local doc_keymap = opts.doc_keymap or "<leader>peD"

	vim.keymap.set("n", def_keymap, ":ExtractPyDefs<CR>", {
		noremap = true,
		silent = true,
		desc = "Extract Python definitions only",
	})

	vim.keymap.set("n", doc_keymap, ":ExtractPyDefsWithDocs<CR>", {
		noremap = true,
		silent = true,
		desc = "Extract Python definitions with docstrings",
	})

	return M
end

return M
