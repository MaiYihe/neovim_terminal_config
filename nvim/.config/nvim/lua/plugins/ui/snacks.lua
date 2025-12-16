return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- 让 rename 用浮窗输入（vim.ui.input）
		input = { enabled = true },

		-- 让 code_action 用 picker 选择（vim.ui.select）
		picker = { enabled = true, ui_select = true },

		-- 你要的图片 hover（可选）
		image = {
			enabled = true,
			doc = { enabled = false }, -- 不要自动在文档里渲染
			-- formats 不写也行，snacks 自带默认
		},
	},
	keys = {
		{
			"<leader>im",
			function()
				Snacks.image.hover() -- 用全局 Snacks（文档也是这么写的）
			end,
			desc = "Snacks image hover (manual)",
		},
	},
}
