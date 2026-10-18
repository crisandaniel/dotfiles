# =============================================================================
# 1. ENVIRONMENT VARIABLES AND GLOBAL PATHS (PATH)
# =============================================================================
# Base paths
export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# Load native Homebrew (Apple Silicon) once per session
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Default editor for programs that open one (git commit, crontab -e, kubectl edit, zsh-vi-mode `vv`).
# The `vim=nvim` alias does not apply to them, they run whatever $EDITOR / $VISUAL names.
export EDITOR=nvim
export VISUAL=nvim

# Load personal environment (secrets)
source ~/.zsh_env

# Fix for the zsh-vi-mode plugin (stops the "widgets can only be called when ZLE is active" error)
export ZVM_INIT_MODE=sourcing


# =============================================================================
# 2. OH MY ZSH
# =============================================================================

# DISABLED: Agnoster theme is off because Starship now draws the prompt
# ZSH_THEME="agnoster"

# Active plugins (zsh-vi-mode must be loaded through OMZ)
plugins=(git npm nvm bundler dotenv rake rbenv ruby zsh-vi-mode)

# Start Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# 3. CUSTOM PROMPT WITH KUBERNETES + VI MODE (COMMENTED OUT / INACTIVE)
# =============================================================================
# DISABLED: this whole section is turned off because Starship
# takes this context from starship.toml.
#
# prompt_zvm_status() {
#   case $ZVM_MODE in
#     $ZVM_MODE_NORMAL)      prompt_segment yellow black "🅝 " ;;
#     $ZVM_MODE_INSERT)      prompt_segment green  white "🅨 " ;;
#     $ZVM_MODE_VISUAL)      prompt_segment cyan   black "🅥 " ;;
#     $ZVM_MODE_VISUAL_LINE) prompt_segment blue   white "🅥 " ;;
#     *)                     prompt_segment green  white "🅨 " ;; 
#   esac
# }
#
# prompt_kube() {
#   local ctx
#   ctx=$(kubectl config current-context 2>/dev/null) || return
#   case $ctx in
#     *prod*)    prompt_segment red    white "⎈ PROD: $ctx" ;;
#     *staging*) prompt_segment yellow black "⎈ STAGING: $ctx" ;;
#     *dev*)     prompt_segment cyan   black "⎈ $ctx" ;;
#     *test*)    prompt_segment cyan   black "⎈ $ctx" ;;
#     *)         prompt_segment blue   white "⎈ $ctx" ;;
#   esac
# }
#
# build_prompt() {
#   RETVAL=$?
#   prompt_zvm_status
#   prompt_status
#   prompt_virtualenv
#   prompt_aws
#   prompt_kube
#   prompt_context
#   prompt_dir
#   prompt_git
#   prompt_end
# }

# =============================================================================
# 4. CUSTOM FUNCTIONS AND AUTOMATION (SSH, GPG)
# =============================================================================
# SSH and GPG agent manager
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export SSH_AUTH_SOCK
fi
gpgconf --launch gpg-agent

# SSH wrapper: switches the iTerm2 profile and shows a banner while connected
ssh() {
  local host="${@[-1]}"
  print -u2 -P "%K{red}%F{white}%B  🔒 SSH → $host  %b%f%k"
  printf '\033]0;☠️ SSH: %s\007' "$host" >&2

  [[ $TERM_PROGRAM == iTerm.app ]] && printf '\033]1337;SetProfile=SSH\a' >&2
  command ssh "$@"; local rc=$?
  [[ $TERM_PROGRAM == iTerm.app ]] && printf '\033]1337;SetProfile=Default\a' >&2

  printf '\033]0;%s\007' "${PWD/#$HOME/~}" >&2
  print -u2 -P "%F{green}✔ EXIT FROM SSH ($host)%f"
  return $rc
}

# =============================================================================
# 5. LANGUAGE VERSION MANAGERS (NVM, RBENV, PYENV)
# =============================================================================
# NVM and RBENV are loaded by the Oh My Zsh `nvm` and `rbenv` plugins (see plugins=(...))

# Python Version Manager (PYENV) - --no-rehash for faster startup
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash zsh)"

# =============================================================================
# 6. COMPILERS AND SYSTEM LIBRARIES (OPENSSL, MYSQL, CROWDIN) - old Intel Homebrew paths, disabled
# =============================================================================
# OpenSSL @1.1
#export PATH=/usr/local/opt/openssl@1.1/bin:$PATH
#export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
#export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
#export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# MySQL @5.7
#export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Crowdin CLI
#export PATH="/usr/local/opt/crowdin@4/bin:$PATH"

# =============================================================================
# 7. ALIASES, COMPLETIONS AND PROMPT ENGINE
# =============================================================================
# Kubernetes CLI (kubectl)
source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F _kubectl k

# Neovim aliases
alias vim=nvim
alias vi=nvim

# Command line syntax highlighting (zsh-syntax-highlighting)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# START STARSHIP (must run last so the prompt renders correctly)
eval "$(starship init zsh)"

# =============================================================================
# 8. HOOKS FOR ZSH-VI-MODE + STARSHIP INTEGRATION
# =============================================================================

function toggle_prompt() {
  if [[ -z "$STARSHIP_CONFIG" ]]; then
    export STARSHIP_CONFIG=$HOME/.config/starship-minimal.toml
  else 
    unset STARSHIP_CONFIG
  fi
  zle reset-prompt
}
zle -N toggle_prompt
bindkey -M viins '^o' toggle_prompt 
bindkey -M vicmd '^o' toggle_prompt 

# zsh-vi-mode hooks: keep the Vim mode shown in the Starship prompt in sync
function zvm_after_select_vi_mode() {
  # Redraw the prompt so Starship switches 🅨 to 🅝 immediately
  zle reset-prompt
}

function zvm_after_init() {
  zle reset-prompt
}

