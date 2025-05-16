# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f "$HOME/.exports" ]] && source "$HOME/termsupport.zsh"

# Load env vars
# source "$HOME/.zshenv"

# Enable colors
autoload -Uz colors && colors

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
# https://wiki.archlinux.org/title/Zsh#Key_bindings
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"
key[Alt-Left]="${terminfo[kLFT3]}"
key[Alt-Right]="${terminfo[kRIT3]}"
key[Shift-Control-Left]="${terminfo[kLFT6]}"
key[Shift-Control-Right]="${terminfo[kRIT6]}"
key[Shift-Alt-Left]="${terminfo[kLFT4]}"
key[Shift-Alt-Right]="${terminfo[kRIT4]}"
key[Ctrl-Backspace]="${terminfo[cub1]}"

# Setup key accordingly
[[ -n "${key[Home]}"                ]] && bindkey -- "${key[Home]}"                 beginning-of-line
[[ -n "${key[End]}"                 ]] && bindkey -- "${key[End]}"                  end-of-line
[[ -n "${key[Insert]}"              ]] && bindkey -- "${key[Insert]}"               overwrite-mode
[[ -n "${key[Backspace]}"           ]] && bindkey -- "${key[Backspace]}"            backward-delete-char
[[ -n "${key[Delete]}"              ]] && bindkey -- "${key[Delete]}"               delete-char
[[ -n "${key[Up]}"                  ]] && bindkey -- "${key[Up]}"                   up-line-or-beginning-search
[[ -n "${key[Down]}"                ]] && bindkey -- "${key[Down]}"                 down-line-or-beginning-search
[[ -n "${key[Left]}"                ]] && bindkey -- "${key[Left]}"                 backward-char
[[ -n "${key[Right]}"               ]] && bindkey -- "${key[Right]}"                forward-char
[[ -n "${key[PageUp]}"              ]] && bindkey -- "${key[PageUp]}"               beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"            ]] && bindkey -- "${key[PageDown]}"             end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}"           ]] && bindkey -- "${key[Shift-Tab]}"            reverse-menu-complete
[[ -n "${key[Control-Left]}"        ]] && bindkey -- "${key[Control-Left]}"         backward-word
[[ -n "${key[Control-Right]}"       ]] && bindkey -- "${key[Control-Right]}"        forward-word
[[ -n "${key[Alt-Left]}"            ]] && bindkey -- "${key[Alt-Left]}"             backward-word
[[ -n "${key[Alt-Right]}"           ]] && bindkey -- "${key[Alt-Right]}"            forward-word
[[ -n "${key[Shift-Control-Left]}"  ]] && bindkey -- "${key[Shift-Control-Left]}"   beginning-of-line
[[ -n "${key[Shift-Control-Right]}" ]] && bindkey -- "${key[Shift-Control-Right]}"  end-of-line
[[ -n "${key[Shift-Alt-Left]}"      ]] && bindkey -- "${key[Shift-Alt-Left]}"       beginning-of-line
[[ -n "${key[Shift-Alt-Right]}"     ]] && bindkey -- "${key[Shift-Alt-Right]}"      end-of-line
[[ -n "${key[Ctrl-Backspace]}"      ]] && bindkey -- "${key[Ctrl-Backspace]}"       backward-kill-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Enable completions
autoload -Uz compinit && compinit -u
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

# Load version control information
# - https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information
# - https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info

+vi-git-dirty() {
  local git_status=$(git --no-optional-locks status --porcelain 2> /dev/null | tail -n 1)
  if [[ -n $git_status ]]; then
      hook_com[staged]+="%{$fg[yellow]%}✗%{$reset_color%} "
  fi
}

# Enable git for vcs_info
zstyle ':vcs_info:*' enable git
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:*' nvcsformats ""
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' check-for-staged-changes true
zstyle ':vcs_info:git*' formats "%{$fg[blue]%}%s:(%{$fg[red]%}%b%{$fg[blue]%})%{$reset_color%} %m%u%c"
zstyle ':vcs_info:git*' actionformats "%{$fg[blue]%}%s:(%{$fg[red]%}%b%{$reset_color%}|%{$fg[yellow]%}%a%{$fg[blue]%})%{$reset_color%} " # %m%u%c "
zstyle ':vcs_info:git*' stagedstr "%{$fg[green]%}%{$reset_color%}"
zstyle ':vcs_info:git*' unstagedstr "%{$fg[red]%}%{$reset_color%}"
zstyle ':vcs_info:git*+set-message:*' hooks git-dirty

# Set up the prompt
# - without priviledge information
# - with VCS information
setopt prompt_subst
PROMPT="%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})➜ %{$fg[cyan]%}%1~%{$reset_color%} "
PROMPT+='${vcs_info_msg_0_}'

# History file configuration
[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/.zsh_history"
[[ "$HISTSIZE" -lt 50000 ]] && HISTSIZE=50000
[[ "$SAVEHIST" -lt 10000 ]] && SAVEHIST=10000

# History command configuration
setopt extended_history # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups # ignore duplicated commands history list
setopt hist_ignore_space # ignore commands that start with space
setopt hist_verify # show command with history expansion to user before running it
setopt share_history # share command history data

unsetopt beep # disable beeping
setopt aliases # expand aliases
setopt auto_pushd # make cd push the old directory onto the directory stack
setopt pushd_ignore_dups # don't push the same directory twice
setopt menu_complete # automatically highlight first element of completion menu
setopt auto_list # automatically list choices on ambiguos completion
setopt complete_in_word # complete from both ends of a word
setopt interactive_comments # allow comments in interactive shells

# Disable paste highlight
zle_highlight=('paste:none')

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.exports" ]] && source "$HOME/.exports"

# $HOME/.extras can be used for other settings you don’t want to commit
# shellcheck source=/dev/null
[[ -f "$HOME/.extras" ]] && source "$HOME/.extras"

os_type=$(uname -s)
if [[ "$os_type" == "Linux" ]]; then
  os_id=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"')

  if [[ "$os_id" == "fedora" ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  elif [[ "$os_id" == "arch" ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
elif [[ "$os_type" == "Darwin" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

source <(fzf --zsh)
