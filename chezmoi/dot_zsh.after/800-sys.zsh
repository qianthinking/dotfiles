export LANG="en_US.UTF-8"
export EDITOR=nvim VISUAL=nvim

setopt no_complete_aliases

export CC='ccache gcc'
export CXX='ccache g++'

# Define your own backward-kill-word-match function
backward-kill-word-match() {
    local WORDCHARS='[A-Za-z0-9_]'
    zle backward-kill-word
}
zle -N backward-kill-word-match
bindkey '^W' backward-kill-word-match

alias micromamba=conda

ulimit -n 65535
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH

export HISTSIZE=10000000
export SAVEHIST=10000000

export GOPATH="$HOME/.go"

path_prepend "$HOME/bin" "$HOME/.local/bin" "${KREW_ROOT:-$HOME/.krew}" "$GOPATH/bin"
