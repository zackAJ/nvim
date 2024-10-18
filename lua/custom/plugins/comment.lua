return {
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = true },
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			require("which-key").add({
				{ "gb", group = "Comment blockwise" },
				{ "gbc", desc = "Comment toggle current block" },
			})
		end,
	},
}
