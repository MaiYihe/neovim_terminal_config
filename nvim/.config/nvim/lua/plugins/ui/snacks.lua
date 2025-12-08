return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    image = {
      enabled = true,
      backend = "kitty",
      formats = { "png", "jpg", "jpeg", "webp", "gif" },

      -- ✅ 关键：关闭文档自动图片行为
      doc = { enabled = false },
    },
  },
  keys = {
    {
      "<leader>im",
      function()
        require("snacks").image.hover()
      end,
      desc = "Snacks image hover (manual)",
    },
  },
}

