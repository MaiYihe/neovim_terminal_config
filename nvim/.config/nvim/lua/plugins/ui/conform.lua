return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
		},
		format_on_save = {
			lsp_fallback = true,
			timeout_ms = 2000,
		},
	},
}
