return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",

	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		-- ⭐ 1️⃣ 编辑距离函数
		local function levenshtein(s, t)
			local m, n = #s, #t
			local d = {}
			for i = 0, m do
				d[i] = {}
				d[i][0] = i
			end
			for j = 0, n do
				d[0][j] = j
			end

			for i = 1, m do
				for j = 1, n do
					if s:sub(i, i) == t:sub(j, j) then
						d[i][j] = d[i - 1][j - 1]
					else
						d[i][j] = math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + 1)
					end
				end
			end
			return d[m][n]
		end
		-- ⭐ 2️⃣ 编辑距离 comparator
		local function comparator_by_distance(entry1, entry2)
			local line = vim.api.nvim_get_current_line()
			local col = vim.fn.col(".") - 1
			local input = line:sub(1, col):match("%w*$") or ""

			local label1 = entry1.completion_item.label
			local label2 = entry2.completion_item.label

			local d1 = levenshtein(input, label1)
			local d2 = levenshtein(input, label2)

			if d1 ~= d2 then
				return d1 < d2
			end
		end

		cmp.setup({
			-- 开启代码补全
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),

			-- 代码补全提示，排序规则
			sorting = {
				comparators = {
					comparator_by_distance, -- 1️⃣ 编辑距离优先
					-- 2️⃣ 已 import / favorite 排前
					function(entry1, entry2)
						local function is_fav(item)
							return item.completion_item.detail and item.completion_item.detail:match("^java%.util")
						end
						if is_fav(entry1) and not is_fav(entry2) then
							return true
						elseif not is_fav(entry1) and is_fav(entry2) then
							return false
						end
					end,
					-- 3️⃣ 其他默认排序
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.kind,
					cmp.config.compare.offset,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
		})
	end,
}
