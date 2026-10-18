# 💻 Mac Dotfiles Automated with Ansible

This repository contains my personal configuration files and an automation script powered by **Ansible** to instantly set up a fresh Mac (Apple Silicon / ARM64 architecture).

## 🛠️ What Does This Script Do?
1. **Homebrew** – Installs the package manager automatically if missing.
2. **iTerm2** – Installs the terminal emulator via Homebrew Cask.
3. **Starship** – Installs the prompt engine and links your custom `starship.toml`.
4. **Neovim** – Unpacks your local `tar.gz` archive into `~/apps/` and links the binary globally.
5. **Configuration Semicolons** – Symlinks your entire **Neovim** structure (`init.lua` + plugins) and your **Zsh** environment (`.zshrc`) into their correct locations.

---

## 🚀 Deployment Guide (For a Fresh Mac)

Open your native macOS Terminal app and execute the following commands:

### Step 1: Copy the Dotfiles Folder to Your Mac
Download, transfer, or clone this `dotfiles` directory to a permanent spot on your new machine (the recommended location is directly in your home folder: `~/dotfiles`).

### Step 2: Install Ansible
macOS comes pre-packaged with Python, meaning you can easily install the automation engine by running:
```bash
pip3 install ansible
```

### Step 3: Run the Setup Playbook
Navigate into your directory and trigger the Ansible execution:
```bash
cd ~/dotfiles
ansible-playbook setup.yml
```
*Note: During execution, macOS might prompt you for your system password or request permission to install the Xcode Command Line Tools required by Homebrew. Enter your credentials and let the script finish its process.*

---

## 🔍 Crucial Post-Installation Check

### 1. Ensure `~/.local/bin` is Map-Indexed inside your PATH
For your terminal to pick up the `nvim` command we just deployed locally, your `.zshrc` file **must** include the following line (make sure this snippet is present in your config):
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 2. Idempotency & Future Updates
If you tweak your `.lua` plugin settings or modify the `setup.yml` tasks in the future, you can safely re-run `ansible-playbook setup.yml` at any time. Ansible will automatically skip existing applications and instantly map over only your newest modifications.

---

## ⌨️ Shortcuts

The config keeps custom shortcuts to a minimum and relies on Vim / Neovim defaults where they exist.
Inside Neovim, `Space ?` opens the full cheat sheet (`nvim/cheatsheet.txt`): the custom shortcuts below (`vim-custom:`) plus the standard Vim cheat sheet from [vim.rtorr.com](https://vim.rtorr.com) (`vim:`).

### Zsh

| Shortcut / command | What it does |
|---|---|
| `Ctrl-o` | Toggle between the full and the minimal Starship prompt |
| `Esc` | Normal mode on the command line (zsh-vi-mode); the prompt switches from 🅨 to 🅝 |
| `vv` (normal mode) | Edit the current command in Neovim (`$EDITOR`); it runs on `:wq` |
| `ssh <host>` | Wrapper: red banner + iTerm2 `SSH` profile while connected, restored on exit |
| `k` | `kubectl` (with completion) |
| `vim`, `vi` | `nvim` |

Oh My Zsh plugins: `git` (aliases such as `gst`, `gco`, `gcb`, `gcmsg`, `gp`, `gl`, `glog`), `npm`, `nvm`, `bundler` (`be`, `bi`), `dotenv` (auto-loads `.env` when entering a folder), `rake`, `rbenv`, `ruby`, `zsh-vi-mode`.

### Neovim (Leader = `Space`)

**Custom**

| Shortcut | What it does |
|---|---|
| `Space q` | Close current file (buffer) |
| `Space n` | Toggle Neo-tree on the left (opens at the current file) |
| `q` / `?` (inside Neo-tree) | Close Neo-tree / show its shortcuts |
| `Space t` | Toggle the bottom terminal (from normal mode) |
| `Esc Esc` (inside the terminal) | Back to Neovim normal mode (default: `Ctrl-\ Ctrl-n`); a single `Esc` goes to zsh |
| `Space ff` | Find files by name (Telescope) |
| `Space fg` | Search text in the whole project (live grep) |
| `Space fb` | List open files (buffers) |
| `Space fh` | Search Neovim help |
| `Space ?` | Open the cheat sheet |
| ``Space ` `` | Active shortcuts in the current buffer (which-key) |

**Defaults worth remembering**

| Shortcut | What it does |
|---|---|
| `]b` / `[b` | Next / previous file (tabs at the top) |
| `Ctrl-w h` / `j` / `k` / `l` | Focus window left / down / up / right (normal mode) |
| `Ctrl-w w` / `Ctrl-w p` | Next (cycle) / previous window |
| `Ctrl-w s` / `Ctrl-w v` | Split horizontally / vertically |
| `Ctrl-w q` / `Ctrl-w o` | Close the current window / close all other windows |

From the terminal, first press `Esc Esc` to get to normal mode, then use `Ctrl-w ...`.

**Disabled**: autocomplete (blink.cmp) and LSP are commented out in `nvim/lua/plugins/lsp.lua`. If re-enabled, Neovim 0.12 already provides the LSP shortcuts by default: `K` (docs), `grn` (rename), `gra` (code actions), `grr` (references), `gri` (implementation), `[d` / `]d` (diagnostics), `Ctrl-w d` (diagnostic on the current line).

