-- 更好的代码补全体验（比如 for、if、sout）
return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()  -- 载入全部现成 snippet
    end,
  },
}

