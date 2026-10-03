# =============================================================================
# 1. VARIABILE DE MEDIU ȘI CĂI GLOBALE (PATH)
# =============================================================================
# Setare căi de bază
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:/opt/homebrew/bin:$PATH

# Încarcă mediul personal
source ~/.zsh_env

# Fix pentru pluginul zsh-vi-mode (Oprește eroarea "widgets can only be called when ZLE is active")
export ZVM_INIT_MODE=sourcing

# Încarcă Homebrew nativ (Apple Silicon) o singură dată pe sesiune
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# =============================================================================
# 2. CONFIGURARE OH MY ZSH
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"

# COMENTAT PENTRU OPTIMIZARE: Dezactivăm Agnoster deoarece Starship controlează acum promptul
# ZSH_THEME="agnoster"

# Plugin-uri active (zsh-vi-mode trebuie să fie încărcat prin OMZ)
plugins=(git npm nvm bundler dotenv rake rbenv ruby zsh-vi-mode)

# Lansare Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# 3. PERSONALIZARE PROMPT & INTEGRARE KUBERNETES + VI MODE (COMENTATĂ / INACTIVĂ)
# =============================================================================
# COMENTAT: Toată această secțiune a fost dezactivată curat pentru că Starship 
# preia contextul din fișierul starship.toml.
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
# 4. FUNCȚII CUSTOM ȘI AUTOMATIZĂRI (SSH, GPG)
# =============================================================================
# Manager Agent SSH și GPG
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export SSH_AUTH_SOCK
fi
gpgconf --launch gpg-agent

# Wrapper SSH inteligent pentru iTerm2 și profile vizuale
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
# 5. CONFIGURĂRI LIMBAJE DE PROGRAMARE & MEDII (NVM, RBENV, PYENV)
# =============================================================================
# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ruby Version Manager (RBENV)
eval "$(rbenv init - --no-rehash zsh)"

# Python Version Manager (PYENV) - adăugat no-rehash pentru optimizare de viteză
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash zsh)"

# =============================================================================
# 6. COMPILATOARE ȘI BIBLIOTECI DE SISTEM (OPENSSL, MYSQL, CROWDIN)
# =============================================================================
# OpenSSL @1.1
export PATH=/usr/local/opt/openssl@1.1/bin:$PATH
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# MySQL @5.7
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Crowdin CLI
export PATH="/usr/local/opt/crowdin@4/bin:$PATH"

# API Keys
export YOUTUBE_API_KEY=AIzaSyC1wK9drpdO4Me3S3IC71UuGb01E48RiEM

# =============================================================================
# 7. ALIAS-URI, COMPLETĂRI AUTOMATE ȘI LANSARE MOTOARE PROMPT
# =============================================================================
# Configurare Kubernetes CLI (Kubectl)
source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F _kubectl k

# Alias-uri globale Neovim
alias vim=nvim
alias vi=nvim

# Evidențiere sintaxă în consolă (Zsh Syntax Highlighting)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# LANSARE STARSHIP (Trebuie rulat la final pentru a asigura randarea optimă)
eval "$(starship init zsh)"

# =============================================================================
# 8. HOOK-URI ȘI CONFIGURĂRI PENTRU ZSH-VI-MODE + STARSHIP INTEGRATION
# =============================================================================
# COMENTAT: Vechile reguli pentru RPS1 au fost oprite curat
# function zvm_after_select_vi_mode() {
#   RPS1="$(zvm_custom_status)"
#   zle .reset-prompt
# }
# function zvm_after_init() {
#   RPS1="$(zvm_custom_status)"
#   zle .reset-prompt
# }

# NOIle HOOK-URI: Sincronizează nativ stările Vim direct în promptul din Starship
function zvm_after_select_vi_mode() {
  # Trimite notificare către Starship să schimbe litera 🅨 în 🅝 instantaneu
  zle reset-prompt
}

function zvm_after_init() {
  zle reset-prompt
}

