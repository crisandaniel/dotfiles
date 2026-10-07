return {
  "sudormrfbin/cheatsheet.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons", lazy = true }, 
  },
  cmd = { "Cheatsheet", "CheatsheetEdit" },
  keys = {
    { "<leader>?", "<cmd>Cheatsheet<cr>", desc = "Deschide Cheat Sheet" }
  },
  -- Fișierul meu e citit automat: pluginul caută `cheatsheet.txt` în folderul de config (~/.config/nvim/)
  -- Îl editez rapid cu :CheatsheetEdit (sau Ctrl-e din fereastra de cheatsheet)
  opts = {
    bundled_cheatsheets = true,        -- cheatsheet-urile incluse în plugin (vim, lua, regex, emoji etc.)
    bundled_plugin_cheatsheets = true, -- cheatsheet-uri pentru pluginurile instalate (ex. telescope)
  },
}

