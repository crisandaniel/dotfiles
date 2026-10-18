return {
  "sudormrfbin/cheatsheet.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons", lazy = true }, 
  },
  cmd = { "Cheatsheet", "CheatsheetEdit" },
  keys = {
    { "<leader>?", "<cmd>Cheatsheet<cr>", desc = "Open cheat sheet" }
  },
  -- My file is read automatically: the plugin looks for `cheatsheet.txt` in the config folder (~/.config/nvim/)
  -- Quick edit with :CheatsheetEdit (or Ctrl-e from the cheat sheet window)
  opts = {
    bundled_cheatsheets = true,        -- cheat sheets bundled with the plugin (vim, lua, regex, emoji etc.)
    bundled_plugin_cheatsheets = true, -- cheat sheets for installed plugins (e.g. telescope)
  },
}

