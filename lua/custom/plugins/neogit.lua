return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		local neogit = require("neogit").setup({})
		vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "[N]eogit" })
	end,
}
