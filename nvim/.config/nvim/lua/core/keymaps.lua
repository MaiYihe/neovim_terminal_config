-- 撤销键:ctrl+z
vim.keymap.set({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>", { silent = true })

-- 命令行模式：候选菜单弹出时用 ↑ / ↓ 选择补全
vim.keymap.set("c", "<Down>", function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
end, { expr = true })

vim.keymap.set("c", "<Up>", function()
	return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
end, { expr = true })

-- 自动格式化快捷键
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, { desc = "Format file" })

-- Visual 模式 Tab 缩进 → 右缩进，且保持选区
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Visual indent right" })
-- Visual 模式 Shift+Tab 缩进 → 左缩进，且保持选区
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Visual indent left" })

-- 快捷键 lw（lineWrap），控制行是否 wrap（是否要自动换行显示）
vim.keymap.set("n", "<leader>lw", function()
	vim.wo.wrap = not vim.wo.wrap
	print(vim.wo.wrap and "➕ wrap" or "➖ nowrap")
end, { desc = "Toggle wrap/nowrap" })

-- grr 引用弹窗
vim.keymap.set("n", "grr", function()
	require("telescope.builtin").lsp_references({
		include_declaration = true,
		show_line = true,
		trim_text = true,
	})
end, { silent = true, noremap = true, desc = "LSP References (Telescope)" })

-- rn 重命名快捷键
vim.keymap.set("n", "rn", function()
  vim.cmd("silent write")
  vim.lsp.buf.rename()
end, { desc = "Safe rename (write before)" })
