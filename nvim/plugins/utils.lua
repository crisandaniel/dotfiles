return {
  {
    "Crysthamus/nvim-file-operations",
    -- Îi spunem explicit: NU porni deloc până când Neo-tree nu este încărcat complet!
    dependencies = { "nvim-neo-tree/neo-tree.nvim" },
    config = function()
      require("nvim-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
}

