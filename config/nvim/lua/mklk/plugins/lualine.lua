return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			grey_gruv = "#a99a85",
			green = "#8db583",
			green_bright = "#b0b846",
			yellow = "#d7a758",
			red = "#e66a64",
			fg = "#c3ccdc",
			bg = "#393533",
			inactive_bg = "#303030",
			cyan = "#80aa9e",
			cyan_bright = "71b9a4",
			dark_grey = "#5a524c",
			sand = "dcd6c3",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.grey_gruv, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		-- configure lualine with modified theme

		local function isRecording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end -- Not recording
			local icon = " " -- Nerd Font camera icon
			return icon .. "rec [" .. reg .. "]"
		end

		local function mode()
			-- Map of modes to their respective shorthand indicators
			local mode_map = {
				n = "N", -- Normal mode
				i = "I", -- Insert mode
				v = "V", -- Visual mode
				[""] = "V", -- Visual block mode
				V = "V", -- Visual line mode
				c = "C", -- Command-line mode
				no = "N", -- NInsert mode
				s = "S", -- Select mode
				S = "S", -- Select line mode
				ic = "I", -- Insert mode (completion)
				R = "R", -- Replace mode
				Rv = "R", -- Virtual Replace mode
				cv = "C", -- Command-line mode
				ce = "C", -- Ex mode
				r = "R", -- Prompt mode
				rm = "M", -- More mode
				["r?"] = "?", -- Confirm mode
				["!"] = "!", -- Shell mode
				t = "T", -- Terminal mode
			}
			-- Return the mode shorthand or [UNKNOWN] if no match
			return mode_map[vim.fn.mode()] .. "" or "[UNKNOWN]"
		end

		local config = {
			options = {
				section_separators = { left = "", right = "" }, -- { left = "", right = "" }, { left = "", right = "" }
				component_separators = "",
				theme = my_lualine_theme,
			},
			disabled_filetypes = {
				"neo-tree",
				"undotree",
				"sagaoutline",
				"diff",
			},
			sections = {
				lualine_a = {
					{
						mode,
						color = function()
							return {
								fg = colors.BG,
								gui = "bold",
							}
						end,
						padding = { left = 1, right = 0 },
					},
				},
				lualine_b = {
					{
						"branch",
						icon = { "󰊢 ", color = { fg = colors.green_bright } },
						color = { fg = colors.green_bright },
						padding = { left = 0, right = 1 },
					},
					{
						function()
							local session_name = require("auto-session.lib").current_session_name(true)
							if session_name and session_name ~= "" then
								return "" .. session_name .. ""
							else
								return ""
							end
						end, --  
						color = { fg = colors.cyan_bright, bg = colors.bg },
						padding = { left = 0, right = 1 },
					},
				},
				-- lualine_a = { "mode" },
				-- lualine_b = { "branch", "diff", "diagnostics" },
				-- lualine_x = {'encoding', 'fileformat', 'filetype'},
				-- lualine_y = {'progress'},
				-- lualine_z = {'location'}

				lualine_c = {
					{
						"buffers",

						icons_enabled = false,
						show_filename_only = true,
						hide_filename_extension = false,
						show_modified_status = true,
						mode = 2,
						max_length = vim.o.columns,

						filetype_names = {
							TelescopePrompt = "Telescope",
							dashboard = "Dashboard",
							packer = "Packer",
							fzf = "FZF",
							alpha = "Alpha",
						},

						disabled_buftypes = { "quickfix", "prompt" },

						symbols = {
							modified = " ●", -- Text to show when the buffer is modified
							alternate_file = " ", -- Text to show to identify the alternate file
							directory = "", -- Text to show when the buffer is a directory
						},

						-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
						use_mode_colors = false,

						buffers_color = {
							active = { bg = colors.dark_grey, fg = colors.fg }, -- Color for active buffer.
							inactive = { bg = colors.bg, fg = colors.fg }, -- Color for inactive buffer.
						},
					},
					-- Current buffer is highlighted separately through fmt function above
					-- {
					-- 	"filename",
					-- 	color = {
					-- 		bg = colors.cyan,
					-- 		fg = colors.bg,
					-- 		gui = "bold,italic",
					-- 	},
					-- },
					{ "diagnostics" },
					{ "diff" },
					{ isRecording },
				},

				lualine_x = {
					{
						-- "filetype",
						-- icon_only = true, -- Display only an icon for filetype
					},
				},

				lualine_y = {},
				lualine_z = { "location" },
			},
		}

		require("lualine").setup(config)
	end,
}
