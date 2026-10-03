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

