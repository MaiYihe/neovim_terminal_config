return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"java",
				"javascript",
				"typescript",
				"vue",
				"json",
				"yaml",
				"bash",
				"html",
				"css",
				"vim",
				"python",

				"markdown",
				"markdown_inline",
			},
			indent = { enable = false },
			incremental_selection = {
				enable = true,
				-- <CR> 是回车键，对所在范围进行选区
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					node_decremental = "<BS>",
				},
			},

			highlight = {
				enable = true,
			},

			matchup = {
				enable = true,
			},
		})
	end,
}
