return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			current_line_blame_formatter_opts = {
				relative_time = false,
			},
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]g", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[g", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[g]it [s]tage" })
				map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[g]it [r]est" })
				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[g]it [s]tage selection" })
				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[g]it [r]est selection" })
				map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "[g]it [S]tage buffer" })
				map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "[g]it [u]ndo stage" })
				map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[g]it [R]est buffer" })
				map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[g]it [p]review" })
				map("n", "<leader>gb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "[g]it [b]lame" })
				map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "[g]it [t]oggle line [b]lame" })
				map("n", "<leader>gd", gitsigns.diffthis, { desc = "[g]it [d]iff this" })
				map("n", "<leader>gD", function()
					gitsigns.diffthis("~")
				end, { desc = "[g]it [D]iff ~" })
				map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "[g]it [t]toggle [d]eleted" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[g]it I dont't know wtf is this" })
			end,
		})
	end,
}
