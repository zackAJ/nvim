return {
	"NStefan002/screenkey.nvim",
	lazy = false,
	config = function()
		local screenkey = require("screenkey")
		-- TODO fix position
		screenkey.setup({
			win_opts = {
				row = vim.o.lines - vim.o.cmdheight - 1,
				col = vim.o.columns - 1,
				relative = "editor",
				anchor = "SE",
				width = 30,
				height = 1,
				border = "single",
				title = "",
				title_pos = "center",
				style = "minimal",
				focusable = false,
				noautocmd = true,
			},
		})

		local notify = require("notify")
		local toggleScreenKey = function()
			screenkey.toggle()
			-- change notification position
			notify.setup({
				top_down = screenkey.is_active(),
			})
		end

		vim.keymap.set("n", "<leader>tk", toggleScreenKey, { desc = "[T]oggle [S]creen[K]ey" })
	end,
}
