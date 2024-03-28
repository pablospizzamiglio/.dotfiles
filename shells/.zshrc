# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable colors
autoload -U colors && colors

# Enable completions
autoload -U compinit && compinit -u
_comp_options+=(globdots) # include hidden files

# Use cache for commands using cache
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Auto complete highlights while cycling
zstyle ':completion:*' menu select
# Auto complete with case insenstivity and partial words
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Complete . and .. special directories
zstyle ':completion:*' special-dirs true
# Enable colors for directories and files in the completion menu
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Move through the completion menu backwards
bindkey '^[[Z' reverse-menu-complete # Shift-Tab

# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Load version control information
autoload -Uz vcs_info add-zsh-hook
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' nvcsformats ""
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' check-for-staged-changes true
zstyle ':vcs_info:git*' formats "%{$fg[blue]%}%s:(%{$fg[red]%}%b%{$fg[blue]%})%{$reset_color%} %m%u%c%"
zstyle ':vcs_info:git*' actionformats "%{$fg[blue]%}%s:(%{$fg[red]%}%b%{$reset_color%}|%{$fg[yellow]%}%a%{$fg[blue]%})%{$reset_color%} " # %m%u%c% "
zstyle ':vcs_info:git*' stagedstr "%{$fg[green]%}%{$reset_color%}"
zstyle ':vcs_info:git*' unstagedstr "%{$fg[red]%}%{$reset_color%}"
zstyle ':vcs_info:git*+set-message:*' hooks git-dirty

+vi-git-dirty() {
  local git_status=$(git --no-optional-locks status --porcelain 2> /dev/null | tail -n 1)
  if [[ -n $git_status ]]
  then
    hook_com[staged]+="%{$fg[yellow]%}✗%{$reset_color%} "
  fi
}

# Set up the prompt (with VCS information)
setopt prompt_subst
# PROMPT='-> %1~ ${vcs_info_msg_0_} %# '
PROMPT="%(?:%{$fg_bold[green]%}%1{➜%}:%{$fg_bold[red]%}%1{➜%}) %{$fg[cyan]%}%c%{$reset_color%} "
PROMPT+='${vcs_info_msg_0_}'
RPROMPT='${vcs_info_msg_1_}'

# source ~/.zshenv

# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

# History command configuration
setopt extended_history # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups # ignore duplicated commands history list
setopt hist_ignore_space # ignore commands that start with space
setopt hist_verify # show command with history expansion to user before running it
setopt share_history # share command history data

unsetopt beep # disable beeping
setopt aliases # expand aliases
setopt auto_pushd
setopt menu_complete # automatically highlight first element of completion menu
setopt auto_list # automatically list choices on ambiguos completion
setopt complete_in_word # complete from both ends of a word
setopt interactive_comments # allow comments in interactive shells

# Disable paste highlight
zle_highlight=('paste:none')

source "$HOME/.exports"
source "$HOME/.aliases"

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/shell/key-bindings.zsh

