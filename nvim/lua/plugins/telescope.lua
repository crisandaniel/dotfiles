-- Fuzzy finder. No keymaps on purpose: use the commands directly.
--   :Telescope find_files   -> type part of a file name, Enter opens it
--   :Telescope <Tab>        -> list every available picker
return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      require('telescope').setup({
        defaults = {
          -- Wider window, smaller preview: more room for the file list
          layout_config = {
            horizontal = { width = 0.95, preview_width = 0.4 },
          },
          -- Show "init.lua  nvim/" instead of "nvim/init.lua", so the name is never cut off
          path_display = { 'filename_first' },
        },
        extensions = {
          file_browser = {
            -- Empty prompt: show only the current folder. Once you type: search all subfolders too.
            auto_depth = true,
          },
        },
      })
      pcall(require('telescope').load_extension, 'fzf')
      require('telescope').load_extension('file_browser')
    end,
  },
}
