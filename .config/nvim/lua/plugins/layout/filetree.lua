return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	config = function()
		require("neo-tree").setup({
			enable_git_status = false,
			enable_diagnostics = true,

			window = {
				position = "left",
				width = 32,

				mappings = {
					-- 禁用 f 搜索（不好用）
					["f"] = "noop",

					-- ⭐ 自定义 H 键：控制树内隐藏文件的显隐
					["H"] = "toggle_hidden",

					-- ⭐ 自定义 O 键：递归展开所有子目录
					["O"] = function(state)
						local fs = require("neo-tree.sources.filesystem")
						local root = state.tree:get_node()
						if not root or root.type ~= "directory" then
							return
						end

						-- 收集从当前目录开始的所有“目录节点”和它们的相对深度
						local dirs = {}

						local function collect_dirs(node, depth)
							if node.type ~= "directory" then
								return
							end

							table.insert(dirs, { node = node, depth = depth })

							-- 只在“已经展开”的目录里继续往下找
							-- 没展开的目录先当作“这一层的候选”，等以后再展开
							if node:is_expanded() then
								local children = state.tree:get_nodes(node:get_id()) or {}
								for _, child in ipairs(children) do
									if child.type == "directory" then
										collect_dirs(child, depth + 1)
									end
								end
							end
						end

						-- depth = 0 从当前节点开始算起
						collect_dirs(root, 0)

						-- 找出“最浅的、尚未展开的目录层级”的深度
						local min_depth_not_expanded = nil
						for _, info in ipairs(dirs) do
							local node = info.node
							if not node:is_expanded() then
								if min_depth_not_expanded == nil or info.depth < min_depth_not_expanded then
									min_depth_not_expanded = info.depth
								end
							end
						end

						-- 如果没有任何“未展开的目录”，说明已经到底了
						if min_depth_not_expanded == nil then
							vim.notify("已到达最底层", vim.log.levels.INFO, {
								title = "Neo-tree",
								timeout = 2000, -- ⭐ 2 秒后自动消失
							})
							return
						end

						-- 展开这一层（min_depth_not_expanded）里所有没展开的目录
						for _, info in ipairs(dirs) do
							local node = info.node
							if info.depth == min_depth_not_expanded and not node:is_expanded() then
								fs.toggle_directory(state, node)
							end
						end
					end,
				},

			},

			filesystem = {
				bind_to_cwd = true,
				follow_current_file = {
					enabled = true, -- VSCode 行为：自动定位到当前文件
				},
				use_libuv_file_watcher = true,

				filtered_items = {
					visible = false,
					hide_dotfiles = true,
					hide_gitignored = false,
				},

				-- ⭐ 记住树的展开状态
				retain_existing = true,

				-- ⭐ 自动折叠没有子内容的目录
				group_empty_dirs = true,
			},
		})

		-- ⭐ 最关键：用 toggle 方式开关 Neo-tree
		vim.keymap.set("n", "<leader>e", ":Neotree toggle left<CR>", {
			desc = "Toggle Neo-tree",
		})
	end,
}
