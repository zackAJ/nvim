return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })

		require("mini.surround").setup({
			mappings = {
				add = "<leder>S", -- Add surrounding in Normal and Visual modes
				delete = "<leader>Sd", -- Delete surrounding
				find = "<leader>Sf", -- Find surrounding (to the right)
				find_left = "<leader>SF", -- Find surrounding (to the left)
				highlight = "<leader>Sh", -- Highlight surrounding
				replace = "<leader>Sr", -- Replace surrounding
				update_n_lines = "<leader>Sn", -- Update `n_lines`
				suffix_last = "N", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		})

		-- TODO: fix surround
		require("which-key").add({
			{ "<leader>S", group = "[S]urround" },

			-- { "<leader>Sn", group = "[S]urround [Update] some shit" },
			-- { "<leader>Sd", group = "[S]urround [D]elete" },
			-- { "<leader>Sf", group = "[S]urround [F]ind right" },
			-- { "<leader>SF", group = "[S]urround [F]ind left" },
			-- { "<leader>Sh", group = "[S]urround [H]ighlight" },
			-- { "<leader>Sr", group = "[S]urround [R]eplace" },

			-- { "<leader>Sdn", group = "[N]ext" },
			-- { "<leader>Sfn", group = "[N]ext" },
			-- { "<leader>SFn", group = "[N]ext" },
			-- { "<leader>Shn", group = "[N]ext" },
			-- { "<leader>Srn", group = "[N]ext" },
			--
			-- { "<leader>SdN", group = "[N]ot [N]ext" },
			-- { "<leader>SfN", group = "[N]ot [N]ext" },
			-- { "<leader>SFN", group = "[N]ot [N]ext" },
			-- { "<leader>ShN", group = "[N]ot [N]ext" },
			-- { "<leader>SrN", group = "[N]ot [N]ext" },
		})
	end,
}
