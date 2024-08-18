return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup({
			transparent = true,
			hide_fillchars = true,
			borderless_telescope = false,
			theme = {
				overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
					return {
						Comment = { fg = colors.grey, bg = "NONE", italic = true },
						["@property"] = { fg = colors.pink, bold = true },
						LineNrAbove = { fg = colors.cyan },
						LineNr = { fg = colors.red },
						LineNrBelow = { fg = colors.cyan },
						GitSignsCurrentLineBlame = { fg = colors.cyan },
					}
				end,
			},
		})
	end,
}
