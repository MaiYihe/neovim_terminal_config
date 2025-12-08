-- ============================================================
-- 自动切换 fcitx5 输入法（Linux）
-- 在 Insert 模式离开时保存输入法状态 + 切回英文
-- 在 Insert 模式进入时恢复之前的输入法
-- ============================================================

-- 记录上一次的输入法状态（0 = 英文, 1 = 中文）
local last_ime = 0

-- 判断当前 fcitx5 的输入法状态
local function fcitx_state()
  -- 返回字符串 "0", "1", "2"
  -- 0: 输入法关闭
  -- 1: 激活但无输入法
  -- 2: 中文输入法激活
  local status = vim.fn.system("fcitx5-remote"):gsub("%s+", "")
  return status
end

local function switch_to_english()
  local st = fcitx_state()
  if st == "2" then
    last_ime = 1  -- 记录上次是中文
    vim.fn.system("fcitx5-remote -c") -- 切英文
  else
    last_ime = 0
  end
end

local function switch_back()
  if last_ime == 1 then
    vim.fn.system("fcitx5-remote -o") -- 恢复中文
  end
end

-- =============================
-- 创建 autocmd 组
-- =============================
local ime_augroup = vim.api.nvim_create_augroup("Ime_augroup", { clear = true })

-- Insert 离开：记状态 + 切英文
vim.api.nvim_create_autocmd("InsertLeave", {
  group = ime_augroup,
  callback = function()
    switch_to_english()
  end,
})

-- Insert 进入：恢复上次输入法
vim.api.nvim_create_autocmd("InsertEnter", {
  group = ime_augroup,
  callback = function()
    switch_back()
  end,
})

