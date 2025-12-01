-- 撤销键:ctrl+z
vim.keymap.set({"n","i"}, "<C-z>", "<Cmd>undo<CR>", {silent = true})

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

