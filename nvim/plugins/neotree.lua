return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    -- Forțăm încărcarea prealabilă a acestor 3 librării esențiale:
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible = true,           -- !!! Această linie face ca fișierele ascunse să fie vizibile implicit !!!
            show_hidden_count = true, -- Îți arată câte fișiere ascunse sunt în foldere
            hide_dotfiles = false,    -- Nu mai ascunde fișierele care încep cu punct (.)
            hide_gitignored = false,  -- Opțional: Arată și fișierele din .gitignore (ex: node_modules)
          },
        },
      })
    end
  }
}

