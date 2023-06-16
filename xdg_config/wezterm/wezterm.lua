local wezterm = require("wezterm")

return {
  initial_rows = 84,
  initial_cols = 120,

  color_scheme = "Default Dark (base16)",
  colors = {
    selection_bg = "#3a3a3a",
  },

  font = wezterm.font_with_fallback({
    { family = "Fira Code", weight = "Medium" },
    { family = "Symbols Nerd Font Mono" },
    { family = "Font Awesome 6 Free" },
    { family = "Font Awesome 6 Brands" },
    { family = "Font Awesome v4 Compatibility" },
    { family = "Noto Sans CJK TC" },
    { family = "Noto Sans CJK SC" },
    { family = "Noto Sans CJK JP" },
    { family = "Noto Sans CJK KR" }}),
  font_size = 9,
  freetype_load_flags = "NO_HINTING | NO_BITMAP",
  freetype_load_target = "Light",

  window_frame = {
    font_size = 9,
  },

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

  quote_dropped_files = "Posix",
}
