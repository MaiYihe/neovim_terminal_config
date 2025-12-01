return {
  "folke/tokyonight.nvim",
  enabled = false,
  opts = {
    style = "moon",
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd([[colorscheme tokyonight]])
  end,
}
