# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Loaded before the zinit block below so that fzf-tab's own Tab-completion
# binding (set when it loads) wins over plain fzf's — otherwise fzf-tab's Tab
# binding gets immediately clobbered by this, since it used to run after it.
eval "$(fzf --zsh)"

# Add in Powerlevel 10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode
# must load after zsh-syntax-highlighting (upstream's own requirement)
zinit light zsh-users/zsh-history-substring-search

autoload -Uz compinit
compinit

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# Linux only — macOS already runs its own persistent ssh-agent via launchd
# (com.openssh.ssh-agent), auto-wired to $SSH_AUTH_SOCK in every shell. This
# block spawned a brand new agent on every single shell instead of reusing it,
# leaking dozens of orphaned ssh-agent processes over time.
# eval `ssh-agent -s` >/dev/null 2>&1
# for key in ~/.ssh/*_ed(N); do
#   ssh-add "$key" >/dev/null 2>&1
# done

# Linux only — /home/nsohmers doesn't exist on macOS ($HOME is /Users/nsohmers),
# so these silently did nothing on every shell startup.
# ssh-keygen -f "/home/nsohmers/.ssh/known_hosts" -R "10.79.71.102" >/dev/null 2>&1
# ssh-keygen -f "/home/nsohmers/.ssh/known_hosts" -R "10.99.71.102" >/dev/null 2>&1
# ssh-keygen -f "/home/nsohmers/.ssh/known_hosts" -R "10.9.71.102" >/dev/null 2>&1

export EDITOR='nvim'
export VISUAL="$EDITOR"

# Gerrit-specific push command kept for reference; use an explicit command if
# this workflow is needed again rather than overriding the normal `push`.
# alias gpush="git push origin HEAD:refs/for/main"

alias vim="nvim"

alias ls="eza --classify always --sort ext --group-directories-first"
alias ll="eza --classify always --sort ext --long --all --group-directories-first"
alias lsa="eza --classify always --sort ext --all --group-directories-first"
alias lst="eza --classify always --sort ext --all --tree --level=2"

inv() {
  local -a files
  files=("${(@f)$(fzf -m --preview='bat --color=always {}')}")
  (( ${#files} )) && nvim -- "${files[@]}"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey -e
bindkey '^p' hist_search-backward
bindkey '^n' hist_search-forward

# up/down arrow filters history by what's already typed instead of just cycling.
# bound on both emacs (bindkey -e above) and vi keymaps (viins/vicmd) since
# zsh-vi-mode switches between those live as you type, not the emacs one.
# Plain escape sequences instead of $terminfo[kcuu1]/[kcud1] — that array came up
# empty in testing (terminfo not populated in every environment), these don't.
for keymap in emacs viins vicmd; do
  bindkey -M "$keymap" '^[[A' history-substring-search-up
  bindkey -M "$keymap" '^[[B' history-substring-search-down
done

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'

eval "$(zoxide init --cmd cd zsh)"

# Linux only — /home/nsohmers doesn't exist on macOS ($HOME is /Users/nsohmers).
# export PATH="$PATH:/home/nsohmers/.local/bin"
# if [ -f "/home/nsohmers/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/nsohmers/.config/fabric/fabric-bootstrap.inc"; fi

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/bin:$PATH"

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

[ -d "$HOME/.pixi/bin" ] && export PATH="$HOME/.pixi/bin:$PATH"
