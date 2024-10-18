return {
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>F",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "n",
			desc = "[F]ormat [b]uffer",
		},
	},
	config = function()
		local util = require("conform.util")
		require("conform").setup({
			notify_on_error = true,
			format_on_save = function(bufnr)
				local disabldFiletypes = {
					"c",
					"cpp",
					"php",
					"vue",
					"javascript",
					"blade",
					"html",
					"lua",
				}

				if not disabldFiletypes[vim.bo[bufnr].filetype] then
					return
				end

				return {
					timeout_ms = 500,
					lsp_fallback = not disabldFiletypes[vim.bo[bufnr].filetype],
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				blade = { "bladeFormatter" },
				php = { "pint" },
			},
			formatters = {
				bladeFormatter = {
					options = {
						format_on_save = false,
					},
					meta = {
						url = "https://github.com/shufo/blade-formatter",
						description = "An opinionated blade template formatter for Laravel that respects readability.",
					},
					command = "/home/zackaj/.local/share/nvim/mason/bin/blade-formatter",
					args = { "--stdin" },
					stdin = true,
					cwd = util.root_file({ "composer.json", "composer.lock" }),
				},

				pint = {
					options = {
						format_on_save = false,
					},
					meta = {
						url = "https://github.com/laravel/pint",
						description = "Laravel's formatter",
					},
					command = "/home/zackaj/.local/share/nvim/mason/bin/pint",
					cwd = util.root_file({ "composer.json", "composer.lock" }),
				},
			},
		})
	end,
}
