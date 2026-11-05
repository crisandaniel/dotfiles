return {
  -- toggleterm plugin spec (loaded by lazy.setup):
{
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15, -- Terminal height
      open_mapping = [[<leader>t]], -- Open/close with Space + t (press again to hide)
      -- Normal mode only: otherwise Space in insert/terminal mode would wait for a "t"
      insert_mappings = false,
      terminal_mappings = false,
      direction = "horizontal", -- Bottom, full width
      shade_terminals = true,
      start_in_insert = true, -- Start in insert (terminal) mode
    })

    -- Mappings inside the ToggleTerm terminal
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      -- Double Esc = back to Neovim normal mode (default: Ctrl-\ Ctrl-n).
      -- Single Esc stays with the shell (zsh-vi-mode uses it for normal mode in the prompt)
      vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], opts)
    end

    -- Apply the mappings above only when a terminal is opened
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end
}

}
