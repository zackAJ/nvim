return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup({
			transparent = true,
			italic_comments = false,
			hide_fillchars = true,
			-- Modern borderless telescope theme, also gives you transparent telescope
			borderless_telescope = false,
			terminal_colors = true,
			theme = {
				variant = "default", --"light"
				highlights = { -- See `:h highlight-groups` `:hi`
					-- Complete list can be found in `lua/cyberdream/theme.lua`
				},
				overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
					return {
						Comment = { fg = colors.grey, bg = "NONE", italic = true },
						["@property"] = { fg = colors.pink, bold = true },
						LineNrAbove = { fg = colors.cyan },
						LineNr = { fg = colors.red },
						LineNrBelow = { fg = colors.cyan },
						GitSignsCurrentLineBlame = { link = "", fg = colors.cyan },
					}
				end,
				-- Override a color entirely
				colors = {},
			},
			extensions = {
				alpha = true,
				cmp = true,
				dashboard = true,
				fzflua = true,
				gitpad = true,
				gitsigns = true,
				grapple = true,
				grugfar = true,
				heirline = true,
				hop = true,
				indentblankline = true,
				kubectl = true,
				lazy = true,
				leap = true,
				markdown = true,
				markview = true,
				mini = true,
				noice = true,
				notify = true,
				rainbow_delimiters = true,
				telescope = true,
				treesitter = true,
				treesittercontext = true,
				trouble = true,
				whichkey = true,
			},
		})
	end,
}
