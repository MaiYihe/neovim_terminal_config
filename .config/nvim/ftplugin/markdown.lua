-- 设置一下打开 markdown 文件，自动保存（不用再 :w）
vim.api.nvim_create_autocmd({"TextChanged", "InsertLeave"}, {
  buffer = 0,
  callback = function()
    vim.cmd("silent! write")
  end,
})

-- 基础 Markdown 优化
vim.opt_local.wrap = false
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.conceallevel = 2     -- 隐藏 markdown 符号
vim.opt_local.concealcursor = "nc" -- 在 normal 模式也 conceal
