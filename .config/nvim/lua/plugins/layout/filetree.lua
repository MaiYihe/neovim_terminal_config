return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	config = function()
		---------------------------------------------------------------------------
		-- 1. 多级数字排序
		---------------------------------------------------------------------------
		-- 从文件名中提取多级数字序列，比如：
		-- "1_标题.md"         → { 1 }
		-- "1.2_标题.md"       → { 1, 2 }
		-- "1.2.3_标题.md"     → { 1, 2, 3 }
		-- "1.-1_标题.md"      → { 1, -1 }
		local function extract_number_sequence(name)
			if not name then
				return nil
			end
			name = tostring(name)
			-- 只看 "_" 之前的部分（和你前缀高亮规则对齐）
			local head = name:match("^(.-)_") or name
			-- 必须是 ±数字 开头，否则不当成数字序列
			if not head:match("^[+-]?%d") then
				return nil
			end
			-- 提取开头连续的 数字 / . / - 作为 prefix，例如：
			-- "1.2-前言"    → prefix = "1.2-"
			-- "1.2.3"       → prefix = "1.2.3"
			-- "1.-1"        → prefix = "1.-1"
			local prefix = head:match("^[+-]?[%d%.-]+")
			if not prefix then
				return nil
			end

			local seq = {}

			-- 用 "." 切分多级章节
			for part in prefix:gmatch("[^%.]+") do
				local num = tonumber(part)
				if not num then
					-- 有一段不是合法数字，整个前缀放弃数字排序
					return nil
				end
				table.insert(seq, num)
			end

			if #seq == 0 then
				return nil
			end
			return seq
		end

		local function compare_sequence(a_seq, b_seq)
			local min_len = math.min(#a_seq, #b_seq)

			-- 逐级比较
			for i = 1, min_len do
				local av = a_seq[i]
				local bv = b_seq[i]
				if av ~= bv then
					return av < bv
				end
			end
			-- 公共前缀完全相同 → 短的在前
			if #a_seq ~= #b_seq then
				return #a_seq < #b_seq
			end
			-- 完全一样
			return false
		end

		local function neo_tree_numeric_sort(a, b)
			if not a or not b then
				return false
			end

			local atype = (a.type or ""):lower()
			local btype = (b.type or ""):lower()

			-- 目录优先
			if atype ~= btype then
				return atype == "directory"
			end

			local aname = a.name or a.path or ""
			local bname = b.name or b.path or ""

			-- 提取序号
			local a_seq = extract_number_sequence(aname)
			local b_seq = extract_number_sequence(bname)

			-- 两个都有序号：按层级数字排序
			if a_seq and b_seq then
				if compare_sequence(a_seq, b_seq) then
					return true
				elseif compare_sequence(b_seq, a_seq) then
					return false
				else
					-- 序号相同，字母序兜底
					return aname < bname
				end
			end

			-- 只有一个有序号 → 有序号的排前
			if a_seq and not b_seq then
				return true
			end
			if b_seq and not a_seq then
				return false
			end

			-- 都没有 → 字母序
			return aname < bname
		end

		---------------------------------------------------------------------------
		-- 2. 高亮 + 自定义渲染组件
		---------------------------------------------------------------------------
		vim.api.nvim_set_hl(0, "NeoTreeNumberPrefix", { fg = "#d1a37c", bold = true })

		-- 彩色前缀渲染函数
		local function colored_name(config, node, _)
			local name = node.name or ""

			----------------------------------------------------------------------
			-- ① 仅对「目录」+「markdown 文件」生效
			----------------------------------------------------------------------
			local is_dir = node.type == "directory"
			local is_md = name:lower():sub(-3) == ".md"
			if not (is_dir or is_md) then
				return {
					text = name,
					highlight = config.highlight or "NeoTreeFileName",
				}
			end
			----------------------------------------------------------------------
			-- ② 规则：
			--    找到「第一个 _」，看它前面是否有「连续的 数字 或 .」在最开头
			--
			--    例：
			--      "12.3.hello_world.md"
			--        -> 第一个 "_" 之前是 "12.3.hello"
			--        -> 其中前缀数字部分是 "12.3."
			--
			--      "01.第二章_结构.md"
			--        -> 第一个 "_" 之前是 "01.第二章"
			--        -> 前缀数字部分是 "01."
			--
			--      "hello_01.第二章.md"
			--        -> 第一个 "_" 前面不是数字开头 → 不高亮
			----------------------------------------------------------------------
			local underscore_pos = name:find("_")
			if not underscore_pos then
				-- 没有 "_"，不处理
				return {
					text = name,
					highlight = config.highlight or "NeoTreeFileName",
				}
			end
			-- 第一个 "_" 之前的部分
			local head = name:sub(1, underscore_pos - 1)

			-- 从开头匹配「连续的数字或 .」
			local prefix = head:match("^([%d%.-]+)")
			if not prefix then
				-- "_" 前面不是数字开头 → 不处理
				return {
					text = name,
					highlight = config.highlight or "NeoTreeFileName",
				}
			end
			----------------------------------------------------------------------
			-- ③ 计算剩余部分
			----------------------------------------------------------------------
			local rest = name:sub(underscore_pos + 1) -- 跳过 `_`
			----------------------------------------------------------------------
			-- ④ 返回「两段文本」，前一段单独高亮
			----------------------------------------------------------------------
			return {
				{
					text = prefix,
					highlight = "NeoTreeNumberPrefix",
				},
				{
					text = rest,
					highlight = config.highlight or "NeoTreeFileName",
				},
			}
		end

		require("neo-tree").setup({
			enable_git_status = false,
			enable_diagnostics = true,

			-- 首段数字进行排序
			sort_function = neo_tree_numeric_sort,

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
				-- 渲染首段颜色（markdown 等排序文件用）
				components = {
					colored_name = colored_name,
				},
				renderers = {
					file = {
						{ "indent" },
						{ "icon" },
						{ "colored_name" }, -- ← 用自定义的，带色的 name
						{ "diagnostics" },
					},
					directory = {
						{ "indent" },
						{ "icon" },
						{ "colored_name" },
					},
				},

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
