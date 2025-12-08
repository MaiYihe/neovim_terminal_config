return {
  "rcarriga/nvim-notify",
  config = function()
    -- 类型注解
    ---@type table|{setup: fun(opts: table)}
    local notify = require("notify")

    notify.setup({
      stages = "static",   -- ⭐ 更柔和的动画
      timeout = 2000,    -- ⭐ 自动消失时间（可选）
    })

    vim.notify = notify  -- 替换内置 notify
  end,
}
