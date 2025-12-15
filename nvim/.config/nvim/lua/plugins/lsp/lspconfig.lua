return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- capabilities
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			capabilities = cmp_lsp.default_capabilities(capabilities)
		end

		-- on_attach
		local on_attach = function(_, bufnr)
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end
			map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
			map("n", "K", vim.lsp.buf.hover, "Hover")
			map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		end

		-- ⭐ Vue TS plugin 路径（关键）
		local vue_ts_plugin = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

		-- ⭐ ts_ls（必须包含 vue + plugin）
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"typescript",
				"javascript",
				"javascriptreact",
				"typescriptreact",
				"vue",
			},
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_ts_plugin,
						languages = { "vue" },
					},
				},
			},
		})

		-- ⭐ vue_ls
		vim.lsp.config("vue_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
		})
		-- ⭐ 启用（一定放在所有 config 之后）
		vim.lsp.enable({ "ts_ls", "vue_ls" })

		-- ⭐ Lua（Neovim）专用增强：让 Signature Help 真正生效
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true), -- ⭐ Neovim API 类型
					},
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")
	end,
}
