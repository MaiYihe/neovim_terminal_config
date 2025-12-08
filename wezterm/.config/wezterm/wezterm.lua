local wezterm = require("wezterm")

local config = {
  font_size = 12.5,
  font = wezterm.font_with_fallback({
    "FiraCode Nerd Font Mono",
    {
      family = "WenQuanYi Micro Hei",
      weight = "Medium",
    },
  }),

  -- 主题
  color_scheme = "OneHalfDark",

  -- Tabs
  use_fancy_tab_bar = true,
  show_new_tab_button_in_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,

  -- 窗口装饰
  window_decorations = "RESIZE",

  -- 改变字体大小时窗口是否调整尺寸
  adjust_window_size_when_changing_font_size = false,

  -- 窗口内边距
  window_padding = {
    left = 8,
    right = 8,
    top = 10,
    bottom = 0,
  },

  -- 渲染后端
  front_end = "WebGpu",
  webgpu_power_preference = "HighPerformance",

  -- 局部颜色覆盖(防止一些文件看不清)
colors = {
  ansi = {
    "#000000", "#E06C75", "#98C379", "#E5C07B",
    "#61AFEF", "#C678DD", "#56B6C2",
    "#E6E6E6", -- White（加亮）
  },
  brights = {
    "#5A5A5A", "#FF6C6B", "#B5BD68", "#F0DFAF",
    "#61AFEF", "#D19A66", "#8BE9FD",
    "#FFFFFF", -- BrightWhite
  },
}

}

return config
