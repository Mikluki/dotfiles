return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		-- local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			blue = "#a99a85",
			green = "#8db583",
			yellow = "#d7a758",
			red = "#e66a64",
			fg = "#c3ccdc",
			bg = "#393533",
			inactive_bg = "#2c3043",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
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
			local icon = " " -- Nerd Font camera icon
			return icon .. "rec [" .. reg .. "]"
		end

		lualine.setup({
			options = {
				theme = my_lualine_theme,
			},
			sections = {
				-- lualine_a = {'mode'},
				-- lualine_b = {'branch', 'diff', 'diagnostics'},
				-- lualine_x = {'encoding', 'fileformat', 'filetype'},
				-- lualine_y = {'progress'},
				-- lualine_z = {'location'}

				lualine_c = {
					"filename",
					function()
						return require("auto-session.lib").current_session_name(true)
					end,
					{ isRecording },
				}, -- Add macro status here

				lualine_x = {
					-- {
					-- 	lazy_status.updates,
					-- 	cond = lazy_status.has_updates,
					-- 	color = { fg = "#ff9e64" },
					-- },
					-- { "encoding" },
					-- {
					-- 	"fileformat",
					-- 	fmt = function()
					-- 		local format = vim.bo.fileformat
					-- 		if format == "unix" then
					-- 			return " " -- Custom Linux icon
					-- 		elseif format == "dos" then
					-- 			return " " -- Custom Windows icon
					-- 		elseif format == "mac" then
					-- 			return " " -- Custom macOS icon
					-- 		end
					-- 		return format
					-- 	end,
					-- },
					{
						"filetype",
						icon_only = true, -- Display only an icon for filetype
					},
				},
			},
		})
	end,
}
