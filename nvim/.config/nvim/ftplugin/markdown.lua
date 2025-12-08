-- 基础 Markdown 优化
vim.opt_local.wrap = true
vim.opt_local.linebreak = false
vim.opt_local.breakindent = true
vim.opt_local.conceallevel = 2     -- 隐藏 markdown 符号
vim.opt_local.concealcursor = "nc" -- 在 normal 模式也 conceal

-- 关掉“硬换行”（真正往文件里插入换行符的那种）
vim.opt_local.breakindentopt = "shift:2"
vim.opt_local.textwidth = 0         -- 不限制一行最多多少字符
vim.opt_local.wrapmargin = 0        -- 关闭右边距自动换行
vim.opt_local.formatoptions:remove("t")  -- 输入时不要自动在 textwidth 处断行

