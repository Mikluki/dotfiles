local M = {}

-- Helper function to center a window dimension
local function center_in(parent_size, child_size)
	return math.floor((parent_size - child_size) / 2)
end

local function float_win_config()
	local width = math.min(math.floor(vim.o.columns * 0.8), 72)
	local height = math.floor(vim.o.lines * 0.8)

	return {
		relative = "editor",
		width = width,
		height = height,
		col = center_in(vim.o.columns, width),
		row = center_in(vim.o.lines, height),
		border = "single",
	}
end

local function open_floating_file(filepath)
	-- Expand the path properly
	local path = vim.fn.expand(filepath)

	-- Check if the file exists
	if vim.fn.filereadable(path) == 0 then
		vim.notify("File does not exist: " .. path, vim.log.levels.ERROR)
		return
	end

	-- Look for an existing buffer with this file
	local buf = vim.fn.bufnr(path, true)

	-- If the buffer doesn't exist, create one and edit the file
	if buf == -1 then
		buf = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_buf_set_name(buf, path)
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("edit " .. vim.fn.fnameescape(path))
		end)
	end

	local win = vim.api.nvim_open_win(buf, true, float_win_config())
	vim.cmd("setlocal nospell")

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = function()
			-- Check if the buffer has unsaved changes
			if vim.api.nvim_get_option_value("modified", { buf = buf }) then
				vim.notify("save your changes bro", vim.log.levels.WARN)
			else
				vim.api.nvim_win_close(0, true)
			end
		end,
	})

	-- Create a group for our autocommands
	local group = vim.api.nvim_create_augroup("FloatingTodoResize" .. win, { clear = true })

	vim.api.nvim_create_autocmd("VimResized", {
		group = group,
		callback = function()
			-- Check if the window still exists
			local ok, _ = pcall(vim.api.nvim_win_get_number, win)
			if ok then
				pcall(vim.api.nvim_win_set_config, win, float_win_config())
			else
				-- Clean up the autocommand if the window no longer exists
				vim.api.nvim_del_augroup_by_id(group)
			end
		end,
	})
end

local function open_normal_file(filepath)
	local path = vim.fn.expand(filepath)
	if vim.fn.filereadable(path) == 0 then
		vim.notify("File does not exist: " .. path, vim.log.levels.ERROR)
		return
	end
	vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function setup_user_commands(opts)
	local target_file = opts.target_file or "ToDo.md"
	local cwd_target_file = vim.fn.getcwd() .. "/" .. target_file

	if vim.fn.filereadable(cwd_target_file) == 1 then
		opts.target_file = cwd_target_file
	else
		opts.target_file = opts.global_file
	end

	-- Define all paths once
	local paths = {
		local_file = opts.target_file,
		global_file = "~/data/second-brain/ToDo.md",
		self_file = "~/data/second-brain/vault-self/ToDo-self.md",
	}

	vim.api.nvim_create_user_command("FloatToDoLocal", function()
		open_floating_file(paths.local_file)
	end, {})

	vim.api.nvim_create_user_command("FloatToDo", function()
		open_floating_file(paths.global_file)
	end, {})

	vim.api.nvim_create_user_command("FloatToDoSelf", function()
		open_floating_file(paths.self_file)
	end, {})

	return paths -- Return just the paths
end

local function setup_keymaps(paths)
	vim.keymap.set("n", "<leader>td", ":FloatToDo<CR>", { silent = true })
	vim.keymap.set("n", "<leader>ts", ":FloatToDoSelf<CR>", { silent = true })
	vim.keymap.set("n", "<leader>tl", ":FloatToDoLocal<CR>", { silent = true })

	-- Normal buffer keymaps - capture the actual string values
	vim.keymap.set("n", "<leader>tD", function()
		open_normal_file(paths.global_file)
	end, { silent = true })
	vim.keymap.set("n", "<leader>tS", function()
		open_normal_file(paths.self_file)
	end, { silent = true })
	vim.keymap.set("n", "<leader>tL", function()
		open_normal_file(paths.local_file)
	end, { silent = true })
end

M.setup = function(opts)
	local paths = setup_user_commands(opts)
	setup_keymaps(paths)
end

return M
