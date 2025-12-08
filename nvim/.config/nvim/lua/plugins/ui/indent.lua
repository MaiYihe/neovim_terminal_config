return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",

  config = function()
    local ibl = require("ibl")

    ibl.setup({
      indent = {
        char = "▏",
      },
      scope = {
        enabled = false,   -- 先关掉 scope，避免光标叠加
      },
    })

  end,
}

