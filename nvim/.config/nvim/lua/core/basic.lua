vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.autoread = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.o.equalalways = false

-- 默认 Tab 全局使用 4 空格（Java/Python 等）
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- 自动命令：前端 + Lua 的 Tab 统一用 2 空格
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "html", "css", "scss", "lua" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- 内联提示(Inlay Hints,嵌入在代码里面)
vim.lsp.inlay_hint.enable(true)

-- 自动换行
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
-- 防止 Tree 和 诊断区域自动换行
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "neo-tree", "Trouble", "qf" },
	callback = function()
		vim.opt_local.wrap = false
	end,
})

-- 阻止 toggle_terminal 的光标闪烁
vim.opt.guicursor:append("t:block-blinkon0")

-- 全局文件自动保存
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	callback = function()
		vim.cmd("silent! write")
	end,
})
