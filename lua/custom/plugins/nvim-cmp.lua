local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"onsails/lspkind.nvim",
		"f3fora/cmp-spell",
	},
}

-- actuall config
M.config = function()
	local cmp = require("cmp")
	local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local gloabalMapping = {

		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-n>"] = function(fallback)
			if not cmp.select_next_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,

		["<C-p>"] = function(fallback)
			if not cmp.select_prev_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,
	}
	vim.opt.completeopt = { "menu,menuone,noselect,noinsert,preview" }

	cmp.setup({
		completion = { completeopt = "menu,menuone,noinsert,noselect,preview" },
		enabled = true,
		preselect = cmp.PreselectMode.Item,
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert(gloabalMapping),
		sources = cmp.config.sources({
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "buffer", max_item_count = 3 },
			{ name = "path",max_item_count = 5  },
			{ name = "nvim_lsp" },
			{
				name = "spell",
				option = {
					keep_all_entries = false,
					enable_in_context = function()
						return true
					end,
					preselect_correct_word = true,
				},
				max_item_count = 3,
			},
		}),
		formatting = {
			format = function(entry, vim_item)
				local lspkind_ok, lspkind = pcall(require, "lspkind")
				if not lspkind_ok then
					local items = {
						buffer = "﬘ ",
						nvim_lsp = " ",
						luasnip = "󰢱 snip",
						nvim_lua = "nvim 󰢱 ",
						path = " ",
					}
					vim_item.menu = (items)[entry.source.name]
					return vim_item
				else
					return lspkind.cmp_format()(entry, vim_item)
				end
			end,
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

return M
