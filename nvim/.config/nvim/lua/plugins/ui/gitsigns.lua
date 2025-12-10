return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()

    require("gitsigns").setup({
      -- ⭐始终从当前文件向上查找 `.git`，不依赖 cwd
      watch_gitdir = {
        interval = 50,
        follow_files = true,
      },

      attach_to_untracked = true,
      auto_attach = true,

      signs = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },

      signs_staged = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },

      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,

      -- ⭐性能优化 & 大文件安全
      max_file_length = 40000,
      update_debounce = 100,

      -- diff 预览浮窗
      preview_config = {
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    })

    -- ⭐ 关键：确保 JDTLS 启动的 Java buffer 也 attach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          require("gitsigns").attach(args.buf)
        end
      end,
    })
  end,
}

