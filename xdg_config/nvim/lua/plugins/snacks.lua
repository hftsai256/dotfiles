require("snacks").setup({
  -- Skips the full startup pipeline (syntax highlighting, matchparen,
  -- etc.) for files over the size/line threshold, so opening a huge
  -- log or minified file doesn't hang the UI.
  bigfile = {
    enabled = true,
    notify = true,
  },

  -- Inline image rendering when the terminal speaks kitty or iTerm2
  -- graphics. foot does not; snacks then falls back to text.
  image = {
    enabled = true,
    doc = {
      inline = false,
      float = true,
      max_width = 160,
    },
    math = {
      enabled = true,
      latex = { font_size = "normalsize" },
    },
  },

  input = {
    enabled = true,
    border = "single",
    relative = "cursor",
  },

  -- Replaces kdheepak/lazygit.nvim: same LazyGit-in-a-float idea, but
  -- snacks auto-matches your colorscheme for LazyGit's own theme and
  -- takes a real border option instead of the vim.g hack that used to
  -- live at the bottom of this file.
  lazygit = {
    enabled = true,
    win = { border = "single" },
  },

  -- Replaces lukas-reineke/indent-blankline.nvim - same vertical
  -- guide-line idea, plus scope highlighting derived from treesitter
  -- (which is already enabled below) instead of pure indentation
  -- counting.
  indent = {
    enabled = true,
  },

  -- Replaces telescope.nvim (+ its file-browser, fzf-native, and
  -- ui-select extensions) for every fuzzy-find/grep/LSP-list job
  -- below - one plugin instead of four. ui_select is a snacks
  -- default (true), listed here so it's not a silent implicit
  -- behavior.
  picker = {
    enabled = true,
    ui_select = true,
  },

  -- Replaces nvim-tree.lua. Despite "picker" in the name, the
  -- explorer's own default layout is "sidebar" (fixed-width, left
  -- side, no auto-close on opening a file) - it behaves like a
  -- persistent tree, it's just built on the picker engine, so it
  -- gets fuzzy grep/search for free. See config.keymaps for the
  -- <leader>e toggle helper - the explorer itself has no toggle,
  -- only open.
  explorer = {
    enabled = true,
    replace_netrw = true,
    trash = true,
  },

  -- Replaces toggleterm.nvim. Without an explicit cmd, snacks opens
  -- terminals as a bottom split by default - forced back to a
  -- float here to match toggleterm's old float_opts and everything
  -- else in this config.
  terminal = {
    enabled = true,
    win = {
      position = "float",
      border = "single",
    },
  },

  -- Start screen shown when opening nvim with no file arguments.
  -- sections drops the default list's third entry,
  -- { section = "startup" } - that section unconditionally calls
  -- require("lazy.stats") to report plugin count/load time in the
  -- footer, a hard dependency on lazy.nvim as the plugin manager.
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      {
        section = "keys",
        gap = 1,
        padding = 1,
      },
    },
  },

  notifier = {
    enabled = true,
  },

  quickfile = {
    enabled = true,
  },

  scope = {
    enabled = true,
  },

  scroll = {
    enabled = true,
  },

  statuscolumn = {
    enabled = true,
  },

  words = {
    enabled = true,
  },
})
