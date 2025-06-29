# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git)"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel 10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

autoload -Uz compinit
compinit

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

eval `ssh-agent -s` >/dev/null 2>&1
ssh-add ~/.ssh/*_ed >/dev/null 2>&1

ssh-keygen -f "/home/nsohmers/.ssh/known_hosts" -R "10.79.71.102" >/dev/null 2>&1
ssh-keygen -f "/home/nsohmers/.ssh/known_hosts" -R "10.99.71.102" >/dev/null 2>&1
ssh-keygen -f "/home/nsohmers/.ssh/known_hosts" -R "10.9.71.102" >/dev/null 2>&1

EDITOR='nvim'

alias push="git push origin HEAD:refs/for/main"

alias vim="nvim"

alias ls="lsd -FhX --group-directories-first"
alias ll="lsd -FhXlA --group-directories-first"
alias lsa="lsd -AFhX --group-directories-first"
alias lst="lsd -AFhX --tree --depth 2"

alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias google-java-format='java -jar ~/.m2/repository/com/google/googlejavaformat/google-java-format/HEAD-SNAPSHOT/google-java-format-HEAD-SNAPSHOT-all-deps.jar'

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r

### From this line is for pywal-colors
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
#(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
#cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
#source ~/.cache/wal/colors-tty.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey -e
bindkey '^p' hist_search-backward
bindkey '^n' hist_search-forward

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'

eval "$(fzf --zsh)"
source <(fzf --zsh)

eval "$(zoxide init --cmd cd zsh)"

export PATH="$PATH:/home/nsohmers/.local/bin"
if [ -f "/home/nsohmers/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/nsohmers/.config/fabric/fabric-bootstrap.inc"; fi

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/bin:$PATH"
