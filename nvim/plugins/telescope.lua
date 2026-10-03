return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      -- Mutăm extensia nativă ca dependență directă aici:
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      local builtin = require('telescope.builtin')
      
      -- Încarcă extensia FZF în interiorul lui Telescope după pornire
      pcall(require('telescope').load_extension, 'fzf')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
}

