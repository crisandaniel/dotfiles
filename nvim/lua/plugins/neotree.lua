return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    -- Force these 3 required libraries to load first:
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible = true,           -- !!! This line makes hidden files visible by default !!!
            show_hidden_count = true, -- Show how many hidden files each folder has
            hide_dotfiles = false,    -- Don't hide files starting with a dot (.)
            hide_gitignored = false,  -- Optional: also show files from .gitignore (e.g. node_modules)
          },
        },
      })
    end
  }
}

