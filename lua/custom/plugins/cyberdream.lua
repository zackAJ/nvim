return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup({
			-- Enable transparent background
			transparent = true,

			-- Enable italics comments
			italic_comments = false,

			-- Replace all fillchars with ' ' for the ultimate clean look
			hide_fillchars = false,

			-- Modern borderless telescope theme
			borderless_telescope = false,

			-- Set terminal colors used in `:terminal`
			terminal_colors = true,

			theme = {
				variant = "default", -- use "light" for the light variant
				highlights = {
					-- Highlight groups to override, adding new groups is also possible
					-- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

					-- Example:
					Comment = { fg = "#696969", bg = "NONE", italic = true },

					-- Complete list can be found in `lua/cyberdream/theme.lua`
				},

				-- Override a highlight group entirely using the color palette
				overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
					-- Example:
					return {
						Comment = { fg = colors.grey, bg = "NONE", italic = true },
						["@property"] = { fg = colors.pink, bold = true },
						LineNrAbove = { fg = colors.cyan },
						LineNr = { fg = colors.green },
						LineNrBelow = { fg = colors.cyan },
						GitSignsCurrentLineBlame = { fg = colors.cyan },
					}
				end,

				-- Override a color entirely
				colors = {
					-- For a list of colors see `lua/cyberdream/colours.lua`
					-- Example:
					bg = "#000000",
					green = "#00ff00",
					magenta = "#ff00ff",
				},
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
