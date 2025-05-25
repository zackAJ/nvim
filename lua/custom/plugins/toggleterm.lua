return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			direction = "float",
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			vim.keymap.set("n", "<leader>`", "<cmd>ToggleTerm<cr>", { desc = "[T]erminal" })
			require("which-key").add({ { "<leader>`", desc = "[T]erminal" } })
		end,
	},
}
