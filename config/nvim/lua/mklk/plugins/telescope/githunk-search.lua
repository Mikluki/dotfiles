local Job = require("plenary.job")
local Path = require("plenary.path")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Cache mechanism to store hunks and reduce redundant Git commands
local cache = {
	git_root = nil,
	hunks = {},
	last_update = 0,
	cache_ttl = 5, -- Time in seconds before cache is invalidated
}

local config = {
	highlight_groups = {
		add = "GitHunkAdd",
		remove = "GitHunkRemove",
		change = "GitHunkChange",
	},
	keymaps = {
		jump_to_hunk = "<CR>",
		refresh_hunks = "r",
	},
	batch_size = 10, -- Process files in batches for better performance
}

local M = {}

-- Setup highlight groups
local function setup_highlights()
	vim.api.nvim_set_hl(0, config.highlight_groups.add, { fg = "#b0b846" })
	vim.api.nvim_set_hl(0, config.highlight_groups.remove, { fg = "#f2594b" })
	vim.api.nvim_set_hl(0, config.highlight_groups.change, { fg = "#80aa9e" })
end

-- Get git repository root directory
local function get_git_root()
	-- Use cached git root if available
	if cache.git_root then
		return cache.git_root
	end

	local git_root = nil
	Job:new({
		command = "git",
		args = { "rev-parse", "--show-toplevel" },
		on_exit = function(j, _)
			local result = j:result()
			if result[1] then
				git_root = result[1]
				-- Cache the git root
				cache.git_root = git_root
			end
		end,
	}):sync()
	return git_root
end

-- Get list of changed files from git
local function get_changed_files(git_root)
	if not git_root then
		return {}
	end

	local files = {}
	Job:new({
		command = "git",
		args = { "diff", "--name-only" },
		cwd = git_root,
		on_exit = function(j, _)
			files = j:result()
		end,
	}):sync()

	return files
end

-- Process hunks for a batch of files
local function process_files_batch(git_root, files_batch)
	if vim.tbl_isempty(files_batch) then
		return {}
	end

	-- Build command arguments with all files in the batch
	local args = { "diff", "-U0", "--" }
	for _, file in ipairs(files_batch) do
		table.insert(args, file)
	end

	local results = {}
	local diff_output = {}

	-- Run a single git diff command for the batch
	Job:new({
		command = "git",
		args = args,
		cwd = git_root,
		on_exit = function(j, _)
			diff_output = j:result()
		end,
	}):sync()

	-- Parse the diff output
	local current_file = nil
	local current_hunk = nil

	for _, line in ipairs(diff_output) do
		-- Check for file header line (diff --git a/file b/file)
		if vim.startswith(line, "diff --git") then
			current_file = nil
		-- Check for file name in the diff header (+++ b/file)
		elseif vim.startswith(line, "+++ b/") then
			current_file = line:sub(7)
		-- Check for hunk header (@@ -lineold,lineoldcount +linenew,linenewcount @@)
		elseif current_file and vim.startswith(line, "@@") then
			local _, _, added = line:find("%+([0-9]+)")
			current_hunk = {
				file = Path:new(git_root, current_file):absolute(),
				relfile = current_file,
				start = tonumber(added) or 1,
				lines = {},
				header = line,
			}
			table.insert(results, current_hunk)
		-- Add content lines to the current hunk
		elseif current_hunk then
			table.insert(current_hunk.lines, line)
		end
	end

	return results
end

-- Get all git diff hunks with optimized batch processing
local function get_git_diff_hunks(force_refresh)
	local current_time = os.time()

	-- Return cached results if available and not expired
	if not force_refresh and cache.last_update > 0 and (current_time - cache.last_update) < cache.cache_ttl then
		return cache.hunks
	end

	local git_root = get_git_root()
	if not git_root then
		print("Not inside a git repository", vim.log.levels.ERROR)
		return {}
	end

	local files = get_changed_files(git_root)
	if vim.tbl_isempty(files) then
		cache.hunks = {}
		cache.last_update = current_time
		return {}
	end

	local results = {}

	-- Process files in batches for better performance
	for i = 1, #files, config.batch_size do
		local batch_end = math.min(i + config.batch_size - 1, #files)
		local batch = vim.list_slice(files, i, batch_end)
		local batch_results = process_files_batch(git_root, batch)
		vim.list_extend(results, batch_results)
	end

	-- Update the cache
	cache.hunks = results
	cache.last_update = current_time

	return results
end

-- Create entry for telescope finder
local function create_hunk_entry(hunk)
	local hlgroup = "Comment"
	local has_add, has_del = false, false
	local first_line = nil

	for _, line in ipairs(hunk.lines) do
		local prefix = line:sub(1, 1)
		if prefix == "-" then
			has_del = true
			if not first_line then
				first_line = line
			end
		elseif prefix == "+" then
			has_add = true
			if not first_line then
				first_line = line
			end
		elseif not first_line then
			first_line = line
		end
	end

	if has_add and has_del then
		hlgroup = config.highlight_groups.change
	elseif has_add then
		hlgroup = config.highlight_groups.add
	elseif has_del then
		hlgroup = config.highlight_groups.remove
	end

	first_line = first_line or "<no content>"
	local relpath = vim.fn.fnamemodify(hunk.file, ":.")
	local display_line = string.format("%s:%d %s", relpath, hunk.start, first_line)

	return {
		value = {
			filename = hunk.file,
			lnum = hunk.start,
			hunk = hunk,
		},
		ordinal = display_line,
		display = function()
			local start_col = display_line:find(first_line, 1, true) or 0
			return display_line, { { { start_col - 1, #display_line }, hlgroup } }
		end,
		filename = hunk.file,
		lnum = hunk.start,
	}
end

-- Jump to the selected hunk
local function jump_to_hunk(prompt_bufnr)
	local selection = action_state.get_selected_entry()
	actions.close(prompt_bufnr)
	vim.cmd("edit " .. vim.fn.fnameescape(selection.filename))
	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
	end)
end

-- Refresh hunks
local function refresh_hunks(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local hunks = get_git_diff_hunks(true) -- Force refresh

	if vim.tbl_isempty(hunks) then
		print("No hunks in repository", vim.log.levels.INFO)
		actions.close(prompt_bufnr)
		return
	end

	local entries = vim.tbl_map(create_hunk_entry, hunks)
	picker:refresh(
		finders.new_table({
			results = entries,
			entry_maker = function(entry)
				return entry
			end,
		}),
		{ reset_prompt = true }
	)
end

-- Create telescope picker for git hunks
local function hunk_repo_picker()
	local hunks = get_git_diff_hunks()
	if vim.tbl_isempty(hunks) then
		print("No hunks in repository", vim.log.levels.INFO)
		return
	end

	local count = #hunks

	pickers
		.new({}, {
			prompt_title = string.format("Git Hunks in Repo (%d)", count),
			finder = finders.new_table({
				results = hunks,
				entry_maker = create_hunk_entry,
			}),
			sorter = conf.generic_sorter({}),
			previewer = previewers.new_buffer_previewer({
				define_preview = function(self, entry)
					local hunk = entry.value.hunk
					local preview_lines = vim.tbl_map(function(line)
						return line
					end, hunk.lines)

					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)
					vim.bo[self.state.bufnr].filetype = "diff"
				end,
			}),
			attach_mappings = function(prompt_bufnr, map)
				-- Jump to hunk on enter
				map("i", config.keymaps.jump_to_hunk, jump_to_hunk)
				map("n", config.keymaps.jump_to_hunk, jump_to_hunk)

				-- Refresh hunks
				map("i", config.keymaps.refresh_hunks, refresh_hunks)
				map("n", config.keymaps.refresh_hunks, refresh_hunks)

				return true
			end,
		})
		:find()
end

-- Setup function with configuration options
M.setup = function(opts)
	-- Merge user config with defaults
	if opts then
		config = vim.tbl_deep_extend("force", config, opts)
	end

	-- Setup highlights
	setup_highlights()

	-- Register keymaps
	vim.keymap.set("n", "<leader>fh", hunk_repo_picker)
end

return M
