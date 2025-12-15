return {
	"williamboman/mason.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
	},

	lazy = false,
	priority = 900,

	opts = {},

	config = function(_, opts)
		-- Mason UI
		require("mason").setup(opts)

		-- Mason-LSPConfig
		require("mason-lspconfig").setup({
			-- Mason 不会自动清理不在列表里的语言服务器,他只是确保存在
			ensure_installed = {
				-- Java
				"jdtls",

				-- 前端
				"ts_ls",
				"vue_ls", -- ⭐ Vue 正确名称
				"cssls",
				"html",
				"tailwindcss",

				-- 配置文件
				"jsonls",
				"yamlls",
				"lemminx",

				-- Python
				"pyright",

				-- Lua
				"lua_ls",
			},

			automatic_installation = true,

			-- ⭐⭐ 关键：这里排除 jdtls，不要帮我自动启用它
			automatic_enable = {
				exclude = {
					"jdtls",
				},
			},
		})
	end,
}
