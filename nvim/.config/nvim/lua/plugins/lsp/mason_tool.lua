-- 专门用来自动安装格式化器
return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },

	opts = {
		ensure_installed = {
			-- 格式化器(java 的自己提供)
			"stylua", -- lua
			"prettier", -- 前端
			"black", -- python
			"shfmt", -- shell 脚本

			-- === Java (nvim-jdtls required extensions) ===
			"java-debug-adapter",
			"java-test",
		},

		run_on_start = true,
	},
}
