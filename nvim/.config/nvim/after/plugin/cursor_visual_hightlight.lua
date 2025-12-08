-- 选中即时高亮；退出 Visual 自动清除

-- 高亮组
vim.api.nvim_set_hl(0, "VisualInstant", { bg = "#334155" })

-- 清除所有 VisualInstant 匹配
local function clear_visual_matches()
  for _, m in ipairs(vim.fn.getmatches()) do
    if m.group == "VisualInstant" then
      pcall(vim.fn.matchdelete, m.id)
    end
  end
end

-- 高亮当前 Visual 模式选区的内容
local function highlight_visual_selection()
  clear_visual_matches()

  -- 检查是否为 Visual 模式
  local mode = vim.fn.mode()
  if not mode:match("[vV]") then
    return
  end

  -- 获取选区开始/结束位置
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getcurpos())

  if ls == 0 or le == 0 then return end

  -- 获取选中文本
  local lines = vim.fn.getline(math.min(ls, le), math.max(ls, le))

  if ls == le then
    lines[1] = lines[1]:sub(math.min(cs, ce), math.max(cs, ce))
  else
    lines[1] = lines[1]:sub(cs)
    lines[#lines] = lines[#lines]:sub(1, ce)
  end

  local text = table.concat(lines, "\n")
  if not text or text == "" then return end

  -- 转义特殊字符
  text = vim.fn.escape(text, "\\/.*$^~[]")

  -- 添加全文匹配高亮
  vim.fn.matchadd("VisualInstant", text)
end

-- Visual 模式移动光标时刷新高亮
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    if vim.fn.mode():match("[vV]") then
      highlight_visual_selection()
    else
      clear_visual_matches()
    end
  end,
})

-- 离开 Visual 模式时清除高亮
vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function(args)
    local old, new = args.match:match("(.+):(.+)")
    if old and old:match("[vV]") and not new:match("[vV]") then
      clear_visual_matches()
    end
  end,
})
