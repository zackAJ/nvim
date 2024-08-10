return {
	"laytan/cloak.nvim",
	config = function()
		require("cloak").setup({ cloak_character = "🗝️" })
		vim.keymap.set("n", "<leader>te", "<cmd>CloakToggle<CR>", { desc = " toggle env" })
	end,
}
