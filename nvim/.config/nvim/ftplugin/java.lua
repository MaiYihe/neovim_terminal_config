local jdtls = require("jdtls")

vim.notify("java ftplugin loaded", vim.log.levels.INFO)

-- 查找项目根-默认会根据打开的文件，往上找指定后缀
-- 不能匹配 pom.xml，因为每个微服务子模块都有 pom.xml
-- root：不要用 getcwd 兜底，避免 attach 到错误 workspace
local root = vim.fs.root(0, { "mvnw" })
if not root then
	return
end

vim.notify("root = " .. tostring(root))

-- 模块名与哈希——绝对防冲突（同名 repo）
local module_name = vim.fn.fnamemodify(root, ":t")
-- local hash = vim.fn.sha256(root):sub(1, 8)

-- jdtls 安装路径（mason）
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- launcher jar（jdtls 的真正入口）
local launcher = vim.fn.glob(
  jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
)

-- lombok（mason 自带）
local lombok = jdtls_path .. "/lombok.jar"

-- workspace（缓存存放地址）
local hash = vim.fn.sha256(root):sub(1, 8)
local workspace = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. module_name .. "-" .. hash

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

	settings = {
		java = {
			files = {
				-- 排除 target 目录
				exclude = { "target" },
			},
		},
	},

	init_options = {
		bundles = bundles, -- ★★★ 关键：告诉 JDTLS 加载这些扩展
	},
}

jdtls.start_or_attach(config)
