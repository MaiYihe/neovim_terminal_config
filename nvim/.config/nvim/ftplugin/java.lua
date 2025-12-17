local jdtls = require("jdtls")

-- 查找项目根-默认会根据打开的文件，往上找指定后缀
-- 不能匹配 pom.xml，因为每个微服务子模块都有 pom.xml
local root = vim.fs.root(0, { "mvnw" }) or vim.fn.getcwd()

-- 模块名与哈希——绝对防冲突（同名 repo）
local module_name = vim.fn.fnamemodify(root, ":t")
local hash = vim.fn.sha256(root):sub(1, 8)

-- jdtls 安装路径（mason）
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- launcher jar
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- lombok（mason 自带）
local lombok = jdtls_path .. "/lombok.jar"

-- workspace（缓存存放地址）
local workspace = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. module_name .. "_" .. hash

-- JDTLS 扩展（extract method/variable/constant 必须）
local bundles = {}
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(
			vim.fn.stdpath("data")
				.. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
		),
		"\n"
	)
)
vim.list_extend(
	bundles,
	vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"), "\n")
)

-- java 快捷键
local on_attach = function(_, bufnr)
	-- 快捷键助手（减少重复）
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end
	map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
	---- ☕ Java 专用功能（JDTLS 拓展）
	map("n", "<leader>oi", jdtls.organize_imports, "Organize Imports")
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<leader>em", --extract_method
		"<Esc><Cmd>lua require'jdtls'.extract_method(true)<CR>",
		{ noremap = true, silent = true }
	)
	map("n", "<leader>ev", jdtls.extract_variable, "Extract Variable")
	map("n", "<leader>ec", jdtls.extract_constant, "Extract Constant")

end

-- 支持 snippet 补全格式
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- jdtls 配置表
local config = {
	cmd = {
		"java", -- ← 直接使用 PATH / JAVA_HOME 中的 java
		"-javaagent:" .. lombok,

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.level=ALL",

		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",

		"-jar",
		launcher,
		"-configuration",
		jdtls_path .. "/config_linux",
		"-data",
		workspace,
	},

	-- 项目的根路径
	root_dir = root,

	on_attach = on_attach,
	capabilities = capabilities,

	init_options = {
		bundles = bundles, -- ★★★ 关键：告诉 JDTLS 加载这些扩展
		settings = {
			java = {
				files = {
					-- 排除 target 目录
					exclude = { "target" },
				},
			},
		},
	},
}

jdtls.start_or_attach(config)

-- 🔥 停止 jdtls（不影响其他 LSP）
local function stop_jdtls()
	for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
		client:stop()
	end
end

-- 🔥 重启：停止 JDTLS → 重新 start_or_attach 当前项目
vim.api.nvim_create_user_command("JdtlsRestart", function()
	stop_jdtls()
	require("jdtls").start_or_attach(config) -- 这里 config 为 local，可直接捕获
end, {})

-- 🔄 手动启动
vim.api.nvim_create_user_command("JdtlsStart", function()
	require("jdtls").start_or_attach(config)
end, {})

-- 清除 JDTLS 缓存指令
vim.api.nvim_create_user_command("JdtlsNuke", function()
	if not workspace or workspace == "" then
		vim.notify("JDTLS workspace not found", vim.log.levels.WARN)
		return
	end

	vim.notify("Removing JDTLS workspace:\n" .. workspace, vim.log.levels.INFO)

	vim.fn.system({ "rm", "-rf", workspace })

	vim.notify("Done. Restart Neovim or run :JdtlsRestart", vim.log.levels.INFO)
end, {})
