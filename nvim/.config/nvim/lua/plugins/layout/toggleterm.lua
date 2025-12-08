return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- 关键：默认用浮动窗口
      direction = "float",

      -- 漂亮一点的浮动窗口参数（可选）
      float_opts = {
        border = "rounded",
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.8),
        winblend = 0,
      },
    })

    -- 终端模式下按 <Esc> 回到 Normal 模式
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true })
  end,
}

