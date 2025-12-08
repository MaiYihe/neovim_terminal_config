return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = {
    position = "bottom",
    height = 12,

    -- ⭐⭐ 关键选项：让 Trouble 只在当前窗口底部，而不是整个屏幕底部
    win = {
      relative = "win",  -- <─── 解决你的问题的关键
    },
  },

  cmd = "Trouble",

  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
  },
}

