# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

source "$HOME/.aliases"
source "$HOME/.exports"

# $HOME/.extras can be used for other settings you don’t want to commit
# shellcheck source=/dev/null
[ -f "$HOME/.extras" ] && source "$HOME/.extras"
[ -d "$HOME/.devtools/cargo/env" ] && source "$HOME/.devtools/cargo/env"
