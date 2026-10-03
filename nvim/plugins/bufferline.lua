return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons', -- adaugă iconițe frumoase pentru fișiere
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- arată fișierele deschise
          separator_style = "slant", -- oferă un aspect modern, înclinat (opțional: "thin", "thick")
          always_show_bufferline = true,
          -- Trucul critic: împinge tab-urile la dreapta ca să lase loc liber deasupra Neo-tree
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

