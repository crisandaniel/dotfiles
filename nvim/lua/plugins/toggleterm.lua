return {
  -- Adaugă toggleterm în lista ta de pluginuri din lazy.setup:
{
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15, -- Înălțimea terminalului
      open_mapping = [[<C-t>]], -- Se deschide/închide cu Ctrl + t (apasă din nou ca să dispară)
      direction = "horizontal", -- Îl pune jos, pe toată lățimea
      shade_terminals = true,
      start_in_insert = true, -- Intră direct în modul de scriere
    })

    -- Mapări specifice în interiorul terminalului ToggleTerm
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      -- Îți permite să ieși rapid în modul normal cu Esc ca să poți folosi h/j/k/l
      vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
      -- Îți permite să navighezi între ferestre direct din terminal cu Ctrl + săgeți/taste
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    -- Aplică mapările de mai sus doar când terminalul este deschis
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end
}

}
