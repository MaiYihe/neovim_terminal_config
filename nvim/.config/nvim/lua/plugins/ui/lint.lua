-- ts LSP 的替代品
return
{
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- 用 eslint_d（更快）
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      vue = { "eslint_d" },
    }

    -- 关键：monorepo/pnpm 下让它用项目本地的 eslint_d（通过 pnpm exec）
    lint.linters.eslint_d.cmd = "pnpm"
    lint.linters.eslint_d.args = {
      "exec",
      "eslint_d",
      "-f",
      "unix", -- nvim-lint 解析 unix 格式最稳
      "--stdin",
      "--stdin-filename",
      function() return vim.api.nvim_buf_get_name(0) end,
    }

    -- 保存/退出插入/进入缓冲区时触发 lint
    local aug = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      group = aug,
      callback = function()
        -- 只 lint 有文件名的 buffer
        if vim.api.nvim_buf_get_name(0) ~= "" then
          lint.try_lint()
        end
      end,
    })
  end,
}

