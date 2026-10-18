return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      -- Native extension declared as a direct dependency here:
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      local builtin = require('telescope.builtin')

      -- Load the FZF extension into Telescope after startup
      pcall(require('telescope').load_extension, 'fzf')
  
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
}

