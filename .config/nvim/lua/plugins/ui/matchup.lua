return {
  "andymass/vim-matchup",
  event = "UIEnter",

  init = function()
    vim.g.matchup_matchparen_offscreen = { method = "status" }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
  end,
}

