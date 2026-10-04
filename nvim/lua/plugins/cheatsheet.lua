return {
  "sudormrfbin/cheatsheet.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons", lazy = true }, 
  },
  cmd = "Cheatsheet",
  keys = {
    { "<leader>?", "<cmd>Cheatsheet<cr>", desc = "Deschide Cheat Sheet" }
  },
  -- Folosim `init` pentru a seta variabilele globale ÎNAINTE ca pluginul să pornească
  init = function()
    -- Aceasta este comanda magică care îi spune exact unde este fișierul tău custom
    vim.g.cheatsheet_file = vim.fn.stdpath("config") .. "/custom_cheatsheet.txt"
    
    -- Activăm și cheatsheet-urile lui implicite
    vim.g.cheatsheet_bundled_cheatsheets = 1        -- 1 înseamnă true în Vimscript
    vim.g.cheatsheet_bundled_plugin_cheatsheets = 1 -- 1 înseamnă true în Vimscript
  end,
}

