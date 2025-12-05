return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = function()
		-- 根目录识别：以 -1_figures 所在位置为主
		local function project_root()
			local path = vim.fs.find("-1_figures", {
				upward = true,
				stop = vim.loop.os_homedir(),
				type = "directory",
			})[1]

			if path then
				return vim.fn.fnamemodify(path, ":h")
			end

			return vim.fn.getcwd()
		end

		return {
			default = {
				dir_path = function()
					return project_root() .. "/-1_figures"
				end,

				extension = "png",
				file_name = "Pasted_image_%Y%m%d%H%M%S",
				prompt_for_file_name = false,

				-- 🚀 拷贝拖拽图片
				copy_images = true,

				-- 🚀 控制返回相对路径不带 ../
				use_absolute_path = false,
				relative_template_path = true,
			},

			filetypes = {
				markdown = {
					template = function(data)
						-- 1️⃣ 提取真正的路径
						local file_path = type(data) == "string" and data or data.file_path

						-- 2️⃣ 容错：如果仍不是字符串，直接返回基础格式
						if type(file_path) ~= "string" then
							return "![图片]()"
						end

						-- 3️⃣ 只保留 -1_figures/... 部分
						local idx = file_path:match("()-1_figures")
						if idx then
							file_path = file_path:sub(idx)
						end

						return string.format("![图片](%s)", file_path)
					end,

					url_encode_path = false,
					download_images = true,
				},
			},
		}
	end,

	keys = {
		{ "<leader>ip", "<cmd>PasteImage<CR>", desc = "Paste image" },
	},
}
