-- 禁止换行自动补上注释

vim.api.nvim_create_augroup("NoAutoComment", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = "NoAutoComment",
  pattern = "*",
  callback = function()
    -- 关键：一个一个 remove（别用 remove({ ... }) 或 remove("cro")）
    -- vim.opt_local.formatoptions:remove("c")
    -- vim.opt_local.formatoptions:remove("r")
    vim.opt_local.formatoptions:remove("o")
  end,
})

