return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons', -- adds file type icons
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- show open files
          separator_style = "slant", -- modern slanted look (alternatives: "thin", "thick")
          always_show_bufferline = true,
          -- Key trick: push the tabs to the right to leave room above Neo-tree
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              separator = true
            }
          }
        }
      })

    end
  }
}

