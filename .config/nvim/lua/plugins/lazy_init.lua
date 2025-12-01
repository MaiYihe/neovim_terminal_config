-- 因为在 ~/.config/nvim/lua/core/lazy.lua 里写了才能加载该文件夹
-- 导出子文件夹中的 .lua
return {
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
  { import = "plugins.editor" },
  { import = "plugins.layout" },
}
