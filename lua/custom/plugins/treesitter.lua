return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		matchup = {
			enable = true,
			disable = { "c", "ruby" },
		},
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"vim",
			"blade",
			"vimdoc",
			"php",
			"vue",
			"javascript",
			"html",
			"phpdoc",
			"css",
			"json",
			"jsonc",
			"python",
			"query",
			"regex",
			"ruby",
			"typescript",
			"tsx",
			"yaml",
			"toml",
			"markdown_inline",
			"scss",
			"sql",
			"ssh_config",
			"toml",
			"tsx",
			"vue",
			"xml",
			"yaml",
			"astro",
			"go",
			"gomod",
			"gosum",
			"groovy",
			"java",
			"dockerfile",
			"gitattributes",
			"git_config",
			"gitignore",
			"make",
			"nginx",
			"php",
			"python",
			"ini",
			"sql",
			"tsx",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	config = function(_, opts)
		require("nvim-treesitter.install").prefer_git = true
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		parser_config.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}

		-- vim.treesitter.language.register('html', 'blade')

		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}
