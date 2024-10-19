return {
	"neovim/nvim-lspconfig",
	opts = {
		autoformat = false,
	},
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		--NOTE: disposable and sus
		local lsp_zero = require("lsp-zero")
		lsp_zero.extend_lspconfig()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				map("gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

				map(
					"<leader>dws",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					"[D]ynamic [W]orkspace [S]ymbols"
				)

				map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "[W]orkspace [S]ymbols")

				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				map("K", vim.lsp.buf.hover, "Hover Documentation")

				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			tailwindcss = { filetypes = { "html", "blade", "vue" } },
			phpactor = {
				cmd = { "phpactor", "language-server", "-vvv" },
				on_attach = function(client)
					client.server_capabilities.hoverProvider = nil
					client.server_capabilities.workspaceSymbolProvider = nil
					client.server_capabilities.documentSymbolProvider = nil
					client.server_capabilities.referencesProvider = nil
					client.server_capabilities.documentFormattingProvider = nil
					client.server_capabilities.definitionProvider = nil
					client.server_capabilities.typeDefinitionProvider = nil
					client.server_capabilities.diagnosticProvider = nil
					-- client.server_capabilities.completionProvider = nil
				end,
				filetypes = { "php", "blade" },
				settings = {
					phpactor = {
						language_server_phpstan = { enabled = false },
						language_server_psalm = { enabled = false },
						inlayHints = {
							enable = true,
							parameterHints = true,
							typeHints = true,
						},
					},
				},
			},
			intelephense = {
				on_attach = function(client)
					client.server_capabilities.completionProvider = nil
				end,
				settings = { php = { completion = { callSnippet = "Replace" } } },
				cmd = { "intelephense", "--stdio" },
				filetypes = { "php", "blade" },
			},
			ts_ls = {
				settings = {
					ts_ls = {
						tabstop = 2,
					},
				},
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = require("mason-registry").get_package("vue-language-server"):get_install_path()
								.. "/node_modules/@vue/language-server",
							languages = { "vue" },
						},
					},
				},
				filetypes = { "typescript", "vue", "javascript", "javascriptreact", "typescriptreact" },
			},
			volar = {},
			--
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- disable = { 'missing-fields' }
							globals = { "vim" },
						},
					},
				},
			},
		}

		require("mason").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
			"blade-formatter",
			"json-lsp",
			"jsonls",
			"pint",
			"css-lsp",
			"cssls",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
