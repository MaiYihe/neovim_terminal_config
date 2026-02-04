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

-- Markdown: Visual 模式多行在行首添加或删除 "- "
vim.keymap.set("x", "<leader>t-", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local new_lines = {}
  for _, line in ipairs(lines) do
    if line ~= "" then
      if line:sub(1, 2) == "- " then
        table.insert(new_lines, line:sub(3))
      else
        table.insert(new_lines, "- " .. line)
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
end, { buffer = true, desc = "Markdown: add - to lines" })

-- Markdown: Normal 模式当前行切换 "- "（不删除空行）
vim.keymap.set("n", "<leader>t-", function()
  local line = vim.api.nvim_get_current_line()
  if line:sub(1, 2) == "- " then
    vim.api.nvim_set_current_line(line:sub(3))
  else
    vim.api.nvim_set_current_line("- " .. line)
  end
end, { buffer = true, desc = "Markdown: toggle - on line" })
