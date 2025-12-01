return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	opts = function(_, opts)
		-------------------------------------------------------------------
		-- 1. 配置 nvim-cmp（必须写在 function 里）
		-------------------------------------------------------------------
		local cmp = require("cmp")

		cmp.setup.filetype("markdown", {
			sources = cmp.config.sources({
				{ name = "render-markdown" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "nvim_lsp" },
			}),
		})

		-------------------------------------------------------------------
		-- 2. 继续沿用你的 render-markdown 所有配置
		-------------------------------------------------------------------
		opts.callout = {
			note = {
				raw = "[!NOTE]",
				rendered = "󰋽 Note",
				highlight = "RenderMarkdownInfo",
				category = "github",
			},
			tip = {
				raw = "[!TIP]",
				rendered = "󰌶 Tip",
				highlight = "RenderMarkdownSuccess",
				category = "github",
			},
			important = {
				raw = "[!IMPORTANT]",
				rendered = "󰅾 Important",
				highlight = "RenderMarkdownHint",
				category = "github",
			},
			warning = {
				raw = "[!WARNING]",
				rendered = "󰀪 Warning",
				highlight = "RenderMarkdownWarn",
				category = "github",
			},
			caution = {
				raw = "[!CAUTION]",
				rendered = "󰳦 Caution",
				highlight = "RenderMarkdownError",
				category = "github",
			},
			abstract = {
				raw = "[!ABSTRACT]",
				rendered = "󰨸 Abstract",
				highlight = "RenderMarkdownInfo",
				category = "obsidian",
			},
			summary = {
				raw = "[!SUMMARY]",
				rendered = "󰨸 Summary",
				highlight = "RenderMarkdownInfo",
				category = "obsidian",
			},
			tldr = {
				raw = "[!TLDR]",
				rendered = "󰨸 Tldr",
				highlight = "RenderMarkdownInfo",
				category = "obsidian",
			},
			info = {
				raw = "[!INFO]",
				rendered = "󰋽 Info",
				highlight = "RenderMarkdownInfo",
				category = "obsidian",
			},
			todo = {
				raw = "[!TODO]",
				rendered = "󰗡 Todo",
				highlight = "RenderMarkdownInfo",
				category = "obsidian",
			},
			hint = {
				raw = "[!HINT]",
				rendered = "󰌶 Hint",
				highlight = "RenderMarkdownSuccess",
				category = "obsidian",
			},
			success = {
				raw = "[!SUCCESS]",
				rendered = "󰄬 Success",
				highlight = "RenderMarkdownSuccess",
				category = "obsidian",
			},
			check = {
				raw = "[!CHECK]",
				rendered = "󰄬 Check",
				highlight = "RenderMarkdownSuccess",
				category = "obsidian",
			},
			done = {
				raw = "[!DONE]",
				rendered = "󰄬 Done",
				highlight = "RenderMarkdownSuccess",
				category = "obsidian",
			},
			question = {
				raw = "[!QUESTION]",
				rendered = "󰘥 Question",
				highlight = "RenderMarkdownWarn",
				category = "obsidian",
			},
			help = {
				raw = "[!HELP]",
				rendered = "󰘥 Help",
				highlight = "RenderMarkdownWarn",
				category = "obsidian",
			},
			faq = {
				raw = "[!FAQ]",
				rendered = "󰘥 Faq",
				highlight = "RenderMarkdownWarn",
				category = "obsidian",
			},
			attention = {
				raw = "[!ATTENTION]",
				rendered = "󰀪 Attention",
				highlight = "RenderMarkdownWarn",
				category = "obsidian",
			},
			failure = {
				raw = "[!FAILURE]",
				rendered = "󰅖 Failure",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			fail = {
				raw = "[!FAIL]",
				rendered = "󰅖 Fail",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			missing = {
				raw = "[!MISSING]",
				rendered = "󰅖 Missing",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			danger = {
				raw = "[!DANGER]",
				rendered = "󱐌 Danger",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			error = {
				raw = "[!ERROR]",
				rendered = "󱐌 Error",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			bug = {
				raw = "[!BUG]",
				rendered = "󰨰 Bug",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			example = {
				raw = "[!EXAMPLE]",
				rendered = "󰉹 Example",
				highlight = "RenderMarkdownHint",
				category = "obsidian",
			},
			quote = {
				raw = "[!QUOTE]",
				rendered = "󱆨 Quote",
				highlight = "RenderMarkdownQuote",
				category = "obsidian",
			},
			cite = {
				raw = "[!CITE]",
				rendered = "󱆨 Cite",
				highlight = "RenderMarkdownQuote",
				category = "obsidian",
			},
		}

		opts.sign = { enabled = false }

		opts.code = {
			border = "thin",
			left_pad = 1,
			right_pad = 1,
			position = "left",
			language_icon = true,
			language_name = true,
			highlight_inline = "RenderMarkdownCodeInfo",
		}

		opts.heading = {
			icons = { "󰬺 ", "󰬻 ", "󰬼 ", "󰬽 ", "󰬾 ", "󰬿 " },
			border = true,
			render_modes = true,
		}

		opts.checkbox = {
			unchecked = {
				icon = "󰄱",
				highlight = "RenderMarkdownCodeFallback",
				scope_highlight = "RenderMarkdownCodeFallback",
			},
			checked = {
				icon = "󰄵",
				highlight = "RenderMarkdownUnchecked",
				scope_highlight = "RenderMarkdownUnchecked",
			},
		}

		opts.pipe_table = {
			border = {
				"╭",
				"┬",
				"╮",
				"├",
				"┼",
				"┤",
				"╰",
				"┴",
				"╯",
				"│",
				"─",
			},
		}

		opts.anti_conceal = {
			disabled_modes = { "n" },
			ignore = { bullet = true, head_border = true, head_background = true },
		}

		opts.win_options = { concealcursor = { rendered = "nvc" } }

		opts.completions = {
			lsp = { enabled = true },
		}

		-------------------------------------------------------------------
		-- MUST RETURN
		-------------------------------------------------------------------
		return opts
	end,

}
