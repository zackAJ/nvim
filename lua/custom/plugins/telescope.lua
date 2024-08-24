-- NOTE:to check
-- quickfix,loclist,tags,tagstacks
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-symbols.nvim",
		{
			"princejoogie/dir-telescope.nvim",
			config = function()
				require("dir-telescope").setup({
					no_ignore = true,
				})
			end,
		},
		"SalOrak/whaler",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = { ["<c-f>"] = actions.to_fuzzy_refine },
				},
			},
			file_ignore_patterns = { "%.git/" },
			pickers = {
				find_files = {
					file_ignore_patterns = { "%.git/" },
					hidden = true,
					no_ignore = true,
				},
				colorscheme = {
					enable_preview = true,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				["dir"] = {
					require("dir-telescope"),
				},
				whaler = {
					directories = {
						{ path = "~/dev", alias = "dev" },
					},
					auto_file_explorer = false,
					oneoff_directories = {
						{ path = "~/.config", alias = "config" },
						{ path = "~/.config/nvim", alias = "nvim" },
						{ path = "~/notes", alias = "notes" },
						{ path = "~/dotfiles", alias = "dot" },
					},
					file_explorer = "neotree",
				},
			},
		})

		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")
		pcall(telescope.load_extension, "dir")
		pcall(telescope.load_extension, "whaler")

		local builtin = require("telescope.builtin")
		local findInDir = function()
			telescope.extensions.dir.find_files({ no_ignore = true, hidden = true })
		end

		local grepInDir = telescope.extensions.dir.live_grep

		local grepBuffer = function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end

		local findInNvim = function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end

		-- spell
		vim.keymap.set("n", "<leader>sp", builtin.spell_suggest, { desc = "[S][P]ell" })
		vim.keymap.set("n", "<leader>sP", "<cmd>set spell!<cr>", { desc = "[S]pell [T]oggle" })
		-- search
		vim.keymap.set("n", "<leader>sS", builtin.search_history, { desc = "[S]earch [H]istory" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>sR", builtin.registers, { desc = "[S]earch [R]egister" })
		vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "[S]earch [M]arks" })
		vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
		vim.keymap.set("n", "<leader>sC", builtin.command_history, { desc = "[S]earch [C]ommands [H]istory" })
		-- grep
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[G]rep [W]orkspace" })
		vim.keymap.set("n", "<leader>sG", grepInDir, { noremap = true, silent = true, desc = "[Grep] [D]irectory" })
		vim.keymap.set("n", "<leader>s<leader>", grepBuffer, { desc = "[G]rep in Open Files" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch cursor [W]ord" })
		vim.keymap.set("n", "<leader>sf", builtin.current_buffer_fuzzy_find, { desc = "[F]uzzy [F]ind buffer" })
		-- select workspace with whaler
		vim.keymap.set("n", "<leader>fw", telescope.extensions.whaler.whaler)
		-- files
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find buffer" })
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[R]ecent [F]iles" })
		vim.keymap.set("n", "<leader>fa", builtin.find_files, { desc = "[A]ll [F]iles" })
		vim.keymap.set("n", "<leader>ff", builtin.fd, { desc = "[fast] [F]iles" })
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[S]earch in [G]it files" })
		vim.keymap.set("n", "<leader>fd", findInDir, { desc = "[S]elect [D]irectory", noremap = true, silent = true })
		vim.keymap.set("n", "<leader>fn", findInNvim, { desc = "[S]earch [N]eovim files" })
	end,
}
