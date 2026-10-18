-- 1. DISABLE THE NATIVE TREESITTER ENGINE ON LUA FILES TO PREVENT THE ERROR
-- vim.treesitter.start = function() return false end

-- 2. GLOBAL EDITING SETTINGS
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- .tsv files (e.g. Anki flashcards) need real Tabs as separators, not spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tsv",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.list = true -- show Tabs so I don't confuse them with spaces
  end,
})

-- 3. BOOTSTRAP LAZY.NVIM (PLUGIN MANAGER)
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

-- 4. LEADER KEY (must be set before loading Lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 5. AUTO-LOAD ALL PLUGINS FROM THE LUA/PLUGINS/ FOLDER
require("lazy").setup({
  spec = {
    { import = "plugins" }, 
  },
  checker = { enabled = true },
})

-- =============================================================================
-- GLOBAL KEYBOARD SHORTCUTS (MAPPINGS)
-- =============================================================================

-- Close the current tab/buffer with Space + q (without quitting Neovim)
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { silent = true, desc = "Close current file" })

-- DISABLED: window navigation with Ctrl + h/j/k/l. Using the default Ctrl-w h/j/k/l (from normal mode)
-- vim.keymap.set({ "n", "t" }, "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Focus left window" })
-- vim.keymap.set({ "n", "t" }, "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Focus window below" })
-- vim.keymap.set({ "n", "t" }, "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Focus window above" })
-- vim.keymap.set({ "n", "t" }, "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Focus right window" })

-- DISABLED: navigation between the tabs at the top. Using the default ]b / [b (next / previous buffer)
-- vim.keymap.set("n", "<leader><Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next file" })
-- vim.keymap.set("n", "<leader><S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Previous file" })

-- Toggle the Neo-tree explorer with Space + n (opens on the left, revealing the current file)
vim.keymap.set('n', '<leader>n', ':Neotree filesystem toggle reveal left<CR>', { silent = true, desc = 'Toggle Neo-tree on the left' })

-- Open terminal
--[[--
vim.keymap.set('n', '<leader>t', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)
--]]


-- =============================================================================
-- GLOBAL AUTOMATION (AUTO-COMMANDS)
-- =============================================================================

-- Open Neo-tree on the left when Neovim starts and move the cursor to the code
--[[--
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open Neo-tree on startup",
  callback = function()
    vim.cmd("Neotree show")
    vim.cmd("wincmd l")
  end,
})
--]]--

-- Quit Neovim automatically if Neo-tree is the only window left
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Quit if only Neo-tree is left",
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 then
      if vim.bo.filetype == "neo-tree" then
        vim.cmd("quit")
      end
    end
  end,
})

