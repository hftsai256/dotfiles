local wezterm = require("wezterm")

return {
  initial_rows = 84,
  initial_cols = 120,

  color_scheme = "Hybrid",
  colors = {
    selection_bg = "#3a3a3a",
  },

  font = wezterm.font("FiraCode Nerd Font", { weight = "Medium" }),

  leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    {
      key = "\\",
      mods = "LEADER",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "-",
      mods = "LEADER",
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
  },
}
