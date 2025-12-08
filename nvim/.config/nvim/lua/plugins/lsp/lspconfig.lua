return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		"stevearc/dressing.nvim",
	},
	config = function()
		-- 禁用 lspconfig 的 jdtls，避免 nvim-jdtls 被抢先启动
		require("lspconfig").jdtls = nil
		local builtin = require("telescope.builtin")

		-- 🔧 capabilities（包含 completion、signatureHelp 等功能）
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		if ok_cmp then
			capabilities = cmp_lsp.default_capabilities(capabilities)
		end

		-- 要加载的语言服务器列表
		local servers = {
			"ts_ls",
			"vue_ls",
			"jsonls",
			"yamlls",
			"lemminx",
			"cssls",
			"html",
			"pyright",
			"lua_ls",
		}
		-- 为每个 LSP 加载 capabilities
		for _, server in ipairs(servers) do
			vim.lsp.config(server, {
				capabilities = capabilities,
			})
		end

		-- ⭐ 在这里定义所有语言通用的 on_attach
		local on_attach = function(_, bufnr)
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end
			-- ⭐ 通用 LSP 快捷键（所有语言生效）
			map("n", "<leader>rn", vim.lsp.buf.rename, "LSP Rename")
			map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
			map("n", "gd", builtin.lsp_definitions, "LSP Goto Definition")
			map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		end

		-- ⭐ 给每个 LSP 加 capabilities + on_attach
		for _, server in ipairs(servers) do
			vim.lsp.config(server, {
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		-- ⭐ Lua（Neovim）专用增强：让 Signature Help 真正生效
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true), -- ⭐关键！！提供 Neovim API 类型
					},
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		-- TailwindCSS 正确配置（防止附着到 markdown & 防止卡顿！）
		vim.lsp.config("tailwindcss", {
			filetypes = {
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
			},
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern(
					"tailwind.config.js",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.ts",
					"package.json",
					".git"
				)(fname)
			end,
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
