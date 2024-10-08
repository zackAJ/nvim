return { -- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		--NOTE: disposable and sus
		local lsp_zero = require("lsp-zero")
		lsp_zero.extend_lspconfig()
		-- Thus, Language Servers are external tools that must be installed separately from
		-- Neovim. This is where `mason` and related plugins come into play.
		--
		-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				-- Find references for the word under your cursor.
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map(
					"<leader>dws",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					"[D]ynamic [W]orkspace [S]ymbols"
				)

				map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "[W]orkspace [S]ymbols")

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- Opens a popup that displays documentation about the word under your cursor
				--  See `:help K` for why this keymap.
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
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

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local lspconfig = require("lspconfig")
		local servers = {

			-- emmet_ls = {
			-- 	filetypes = {
			-- 		"astro",
			-- 		"blade",
			-- 		"css",
			-- 		"eruby",
			-- 		"html",
			-- 		"htmldjango",
			-- 		"javascriptreact",
			-- 		"less",
			-- 		"pug",
			-- 		"sass",
			-- 		"scss",
			-- 		"svelte",
			-- 		"typescriptreact",
			-- 		"vue",
			-- 	},
			-- },
			--
			tailwindcss = { filetypes = { "html", "blade", "vue" } },
			phpactor = {
				cmd = { "phpactor", "language-server", "-vvv" },
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
					client.server_capabilities.workspaceSymbolProvider = false
					client.server_capabilities.documentSymbolProvider = false
					client.server_capabilities.referencesProvider = false
					client.server_capabilities.completionProvider = false
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.definitionProvider = false
					client.server_capabilities.implementationProvider = true
					client.server_capabilities.typeDefinitionProvider = false
					client.server_capabilities.diagnosticProvider = false
					--
				end,
				filetypes = { "php" },
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
					client.server_capabilities.workspaceSymbolProvider = true
				end,
				settings = { php = { completion = { callSnippet = "Replace" } } },
				cmd = { "intelephense", "--stdio" },
				filetypes = { "php" },
			},
			tsserver = {
				settings = {
					tsserver = {
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
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						diagnostics = {
							-- disable = { 'missing-fields' }
							globals = { "vim" },
						},
					},
				},
			},
		}
		-- 		-- requires plenary (which is required by telescope)
		-- 		local Float = require("plenary.window.float")
		--
		-- 		vim.cmd([[
		--     augroup LspPhpactor
		--       autocmd!
		--       autocmd Filetype php command! -nargs=0 LspPhpactorReindex lua vim.lsp.buf_notify(0, "phpactor/indexer/reindex",{})
		--       autocmd Filetype php command! -nargs=0 LspPhpactorConfig lua LspPhpactorDumpConfig()
		--       autocmd Filetype php command! -nargs=0 LspPhpactorStatus lua LspPhpactorStatus()
		--       autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireStart lua LspPhpactorBlackfireStart()
		--       autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireFinish lua LspPhpactorBlackfireFinish()
		--     augroup END
		-- ]])
		--
		-- 		local function showWindow(title, syntax, contents)
		-- 			local out = {}
		-- 			for match in string.gmatch(contents, "[^\n]+") do
		-- 				table.insert(out, match)
		-- 			end
		--
		-- 			local float = Float.percentage_range_window(0.6, 0.4, { winblend = 0 }, {
		-- 				title = title,
		-- 				topleft = "┌",
		-- 				topright = "┐",
		-- 				top = "─",
		-- 				left = "│",
		-- 				right = "│",
		-- 				botleft = "└",
		-- 				botright = "┘",
		-- 				bot = "─",
		-- 			})
		--
		-- 			vim.api.nvim_buf_set_option(float.bufnr, "filetype", syntax)
		-- 			vim.api.nvim_buf_set_lines(float.bufnr, 0, -1, false, out)
		-- 		end
		--
		-- 		function LspPhpactorDumpConfig()
		-- 			local results, _ = vim.lsp.buf_request_sync(0, "phpactor/debug/config", { ["return"] = true })
		-- 			for _, res in pairs(results or {}) do
		-- 				showWindow("Phpactor LSP Configuration", "json", res["result"])
		-- 			end
		-- 		end
		-- 		function LspPhpactorStatus()
		-- 			local results, _ = vim.lsp.buf_request_sync(0, "phpactor/status", { ["return"] = true })
		-- 			for _, res in pairs(results or {}) do
		-- 				showWindow("Phpactor Status", "markdown", res["result"])
		-- 			end
		-- 		end
		--
		-- 		function LspPhpactorBlackfireStart()
		-- 			local _, _ = vim.lsp.buf_request_sync(0, "blackfire/start", {})
		-- 		end
		-- 		function LspPhpactorBlackfireFinish()
		-- 			local _, _ = vim.lsp.buf_request_sync(0, "blackfire/finish", {})
		-- 		end
		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
