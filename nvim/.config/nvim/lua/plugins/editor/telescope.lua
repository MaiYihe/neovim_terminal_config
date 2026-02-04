return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8", -- 稳定版本
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- ⭐ FZF 加速
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = " λ ",
				selection_caret = " ",
				path_display = { "smart" },
				layout_strategy = "flex",
				sorting_strategy = "ascending",

				mappings = {
          -- 设置仅 Esc 退出 telescope 窗口
					i = {
						["<Esc>"] = require("telescope.actions").close,
						["<LeftMouse>"] = function() end, -- 禁止鼠标左键触发退出
						["<RightMouse>"] = function() end, -- 禁止右键
					},
					n = {
						["<LeftMouse>"] = function() end,
						["<RightMouse>"] = function() end,
					},
				},
			},

			pickers = {
				find_files = {
					hidden = true, -- ⭐可搜索隐藏文件
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		-- 加载 FZF 加速扩展
		telescope.load_extension("fzf")

		-- 搜索相关快捷键（<leader> + f + *）
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old Files" })

	end,
}
