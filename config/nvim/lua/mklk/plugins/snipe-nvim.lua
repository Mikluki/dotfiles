return {
	"leath-dub/snipe.nvim",
	keys = {
		-- {
		-- 	"<leader>ss",
		-- 	function()
		-- 		require("snipe").open_buffer_menu()
		-- 	end,
		-- 	desc = "Open Snipe buffer menu",
		-- },
		{
			"gs",
			function()
				require("snipe").open_buffer_menu()
			end,
			desc = "Open Snipe buffer menu (alt key)",
		},
	},
	opts = {
		ui = {
			---@type integer
			max_height = -1, -- -1 means dynamic height
			-- Where to place the ui window
			-- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
			---@type "topleft"|"bottomleft"|"topright"|"bottomright"|"center"|"cursor"
			position = "center",
			-- Override options passed to `nvim_open_win`
			-- Be careful with this as snipe will not validate
			-- anything you override here. See `:h nvim_open_win`
			-- for config options
			---@type vim.api.keyset.win_config
			open_win_override = {
				-- title = "My Window Title",
				border = "single", -- use "rounded" for rounded border
			},

			-- Preselect the currently open buffer
			---@type boolean
			preselect_current = false,

			-- Set a function to preselect the currently open buffer
			-- E.g, `preselect = require("snipe").preselect_by_classifier("#")` to
			-- preselect alternate buffer (see :h ls and look at the "Indicators")
			---@type nil|fun(buffers: snipe.Buffer[]): number
			preselect = nil, -- function (bs: Buffer[] [see lua/snipe/buffer.lua]) -> int (index)

			-- Changes how the items are aligned: e.g. "<tag> foo    " vs "<tag>    foo"
			-- Can be "left", "right" or "file-first"
			-- NOTE: "file-first" puts the file name first and then the directory name
			---@type "left"|"right"|"file-first"
			text_align = "file-first",
		},

		hints = {
			-- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
			---@type string
			dictionary = "asdflgewchiopm",
		},

		navigate = {
			-- When the list is too long it is split into pages
			-- `[next|prev]_page` options allow you to navigate
			-- this list
			next_page = "J",
			prev_page = "K",

			-- You can also just use normal navigation to go to the item you want
			-- this option just sets the keybind for selecting the item under the
			-- cursor
			under_cursor = "<cr>",

			-- In case you changed your mind, provide a keybind that lets you
			-- cancel the snipe and close the window.
			---@type string|string[]
			cancel_snipe = { "<esc>", "q" },

			-- Close the buffer under the cursor
			-- Remove "j" and "k" from your dictionary to navigate easier to delete
			close_buffer = "D",

			-- Open buffer in vertical split
			open_vsplit = "<C-v>",

			-- Open buffer in split, based on `vim.opt.splitbelow`
			open_split = "H",

			-- Change tag manually
			-- change_tag = "C",
		},
		-- The default s--[[ o ]]rt used for the buffers
		-- Can be any of:
		--  "last" - sort buffers by last accessed
		--  "default" - sort buffers by its number
		--  fun(bs:snipe.Buffer[]):snipe.Buffer[] - custom sort function, should accept a list of snipe.Buffer[] as an argument and return sorted list of snipe.Buffer[]
		-- sort = "default",
		sort = function(buffers)
			table.sort(buffers, function(a, b)
				local name_a = vim.fs.basename(a.name or "")
				local name_b = vim.fs.basename(b.name or "")
				return name_a:lower() < name_b:lower()
			end)
			return buffers
		end,
	},
}
