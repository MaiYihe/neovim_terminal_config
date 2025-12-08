return {
	"akinsho/bufferline.nvim",
    -- 配置和 LSP 的错误信息联动
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(_, _, diagnostics_dict, _)
				local indicator = " "
				for level, number in pairs(diagnostics_dict) do
					local symbol
					if level == "error" then
						symbol = " "
					elseif level == "warning" then
						symbol = " "
					else
						symbol = " "
					end
					indicator = indicator .. number .. symbol
				end
				return indicator
			end,
		},
	},
	keys = {
		{ "<leader>bh", "<Cmd>BufferLineCyclePrev<CR>", silent = true, desc = "Buffer Prev" },
		{ "<leader>bl", "<Cmd>BufferLineCycleNext<CR>", silent = true, desc = "Buffer Next" },
		{ "<leader>bp", "<Cmd>BufferLinePick<CR>", silent = true, desc = "Pick Buffer" },
		{ "<leader>bd", "<Cmd>Bdelete<CR>", silent = true, desc = "Delete Buffer" },
	},
	lazy = false,
}
