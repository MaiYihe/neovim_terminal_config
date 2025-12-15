-- plugins/ui/dressing.lua
return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = { border = "rounded" },
		select = { backend = { "telescope", "builtin" } },
	},
}
