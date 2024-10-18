return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		require("which-key").setup()
		require("which-key").add({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>g", group = "[G]it", mode = { "n", "v" } },
			{ "<leader>f", group = "[F]iles" },
			{ "<leader>dw", desc = "[D]ynamic [W]orkspace" },
			{ "<leader>h", desc = "[H]arpoon" },
		})
	end,
}
