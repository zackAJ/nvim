return {
	"jesseleite/nvim-macroni",
	-- dev = true,
	-- lazy = false,
	config = function()
		require("macroni").setup({})

		local macros = {
			replace_quotes = {
				handler = [[f'<Ignore>a<BS>"<Esc>lf'<Ignore>a<BS>"<Esc>]],
				keymap = "<leader>mcq",
				desc = "[M]a[c]ro [q]uotes",
			},
		}

		local macroni = require("macroni")
		local whichkey = require("which-key")
		for k, macro in pairs(macros) do
			local fn = function()
				macroni.run(macro.handler)
			end
			vim.keymap.set("n", macro.keymap, fn, { remap = true })
			whichkey.add({ macro.keymap, desc = macro.desc })
		end
	end,
}
