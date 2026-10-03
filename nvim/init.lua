-- 1. OPREȘTE MOTORUL NATIV DE TREESITTER PE FIȘIERELE LUA PENTRU A PREVENI EROAREA
-- vim.treesitter.start = function() return false end

-- 2. SETĂRI GLOBALE DE EDITARE
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- 3. BOOTSTRAP LAZY.NVIM (MANAGERUL DE PLUGINURI)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 4. CONFIGURARE TASTĂ LEADER (Trebuie pusă înainte de a încărca setup-ul Lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 5. ÎNCĂRCAREA AUTOMATĂ A PLUGINURILOR DIN FOLDERUL LUA/PLUGINS/
require("lazy").setup({
  spec = {
    { import = "plugins" }, 
  },
  checker = { enabled = true },
})

-- =============================================================================
-- SCURTĂTURI DE TASTATURĂ GLOBALE (MAPPING-URI)
-- =============================================================================

-- Închide tab-ul/buffer-ul curent cu Space + q (fără să închizi Neovim)
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { silent = true, desc = "Închide fișierul curent" })

-- Scurtături de navigare rapidă între ferestre/splits (Stânga / Dreapta)
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Focus fereastră stânga" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Focus fereastră dreapta" })

-- Navigare rapidă între tab-uri de sus (Bufferline) folosind tastele Tab și Shift+Tab
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Următorul fișier" })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Fișierul anterior" })

-- Navigare intre ferestre sus-jos
vim.keymap.set("n", "<leader>k", "<C-w>k<C-w>l", { desc = "Focus fereastră sus" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Focus fereastră jos" })

-- Deschide exploratorul Neo-tree manual cu Space + n
vim.keymap.set('n', '<leader>n', ':Neotree filesystem reveal left<CR>', { desc = 'Deschide Neo-tree în stânga' })

-- Deschide terminal
--[[--
vim.keymap.set('n', '<leader>t', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)
--]]


-- =============================================================================
-- AUTOMATIZĂRI GLOBALE (AUTO-COMMANDS)
-- =============================================================================

-- Deschide automat Neo-tree în stânga la pornirea Neovim și mută cursorul în cod
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Deschide Neo-tree automat la pornire",
  callback = function()
    vim.cmd("Neotree show")
    vim.cmd("wincmd l")
  end,
})

-- Închide Neovim automat dacă singura fereastră rămasă pe ecran este Neo-tree
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Închide editorul dacă a rămas doar Neo-tree",
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 then
      if vim.bo.filetype == "neo-tree" then
        vim.cmd("quit")
      end
    end
  end,
})

