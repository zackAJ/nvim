return {
	"Exafunction/codeium.vim",
	config = function()
		vim.keymap.set("i", "<tab>", function()
			return vim.fn["codeium#Accept"]()
		end, { expr = true, silent = true })
		vim.keymap.set("i", "<A-C-n>", function()
			return vim.fn["codeium#CycleCompletions"](1)
		end, { expr = true, silent = true })
		vim.keymap.set("i", "<A-C-p>", function()
			return vim.fn["codeium#CycleCompletions"](-1)
		end, { expr = true, silent = true })
		vim.keymap.set("i", "<A-C-c>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true, silent = true })

		require("which-key").add({
			{ "<leader>ct", desc = "[C]odeium] [T]oggle" },
		})

		vim.keymap.set("n", "<leader>ct", function()
			vim.g.codeium_enabled = not vim.g.codeium_enabled
		end)
	end,
}
