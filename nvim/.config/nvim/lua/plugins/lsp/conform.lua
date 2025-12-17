-- 格式化器集中管理器（并非安装！）

return
{
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      vue = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      xml = {},           -- 自动 LSP fallback
      java = { "jdtls" }, -- ⭐ jdtls 内置 Formatter
    },
  },
}
