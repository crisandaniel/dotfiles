-- File browser inside Telescope. No keymaps on purpose:
--   :Telescope file_browser                  -> browse from the current working directory
--   :Telescope file_browser path=%:p:h       -> browse from the current file's folder
--
-- No `cmd` here on purpose: it is loaded as a dependency of telescope.nvim
-- (see telescope.lua). Two plugins lazy-loading on the same `Telescope` command
-- made lazy.nvim randomly delete the real command ("Command `Telescope` not found").
return {
  'nvim-telescope/telescope-file-browser.nvim',
  lazy = true,
  dependencies = { 'nvim-lua/plenary.nvim' },
}
