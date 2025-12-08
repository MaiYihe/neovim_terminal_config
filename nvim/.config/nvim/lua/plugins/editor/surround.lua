return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	opts = {
		surrounds = {
			["4"] = {
				add = function()
					return { " **", "** " }
				end,
			},
		},
	},
}
