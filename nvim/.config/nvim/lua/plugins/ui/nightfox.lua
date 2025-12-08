return {
	"EdenEast/nightfox.nvim",
	lazy = false, -- 启动时加载，避免闪烁
	priority = 1000, -- 主题必须最先加载
	opts = {
		options = {
			transparent = false, -- 如果你喜欢透明背景可以改 true
		},
	},
	config = function(_, opts)
		require("nightfox").setup(opts)
		-- 使用 duskfox 主题
    	vim.cmd("colorscheme duskfox")
	end,
}
