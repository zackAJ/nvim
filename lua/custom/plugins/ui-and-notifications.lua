local notificationIcon = "󰂛 "

return {
	-- components
	"folke/noice.nvim",
	enabled = true,
	event = "VeryLazy",
	opts = {
		routes = {
			{
				view = "cmdline",
				-- view = "notify",
				filter = { event = "msg_showmode" },
			},
		},
		lsp = {
			-- override markdown rendering so that
			-- **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		presets = {
			bottom_search = false,
			-- position the cmdline and popupmenu together
			command_palette = false,
			-- long messages will be sent to a split
			long_message_to_split = true,
			-- enables an input dialog for inc-rename.nvim
			inc_rename = false,
			-- add a border to hover docs and signature help
			lsp_doc_border = false,
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			-- notifications
			"rcarriga/nvim-notify",
			config = function()
				local notify = require("notify")
				notify.setup({
					render = "compact",
					timeout = 2000,
					top_down = false,
				})
			end,
			keys = {
				{
					"<leader>tn",
					function()
						local notify = require("notify")
						notify.dismiss({ silent = true, pending = true })
					end,
					desc = notificationIcon .. "Dismiss all Notifications",
				},
			},
		},
	},
}
