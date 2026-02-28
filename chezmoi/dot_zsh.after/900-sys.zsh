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

# alt+.  insert last word; repeat to go back in history
# alt+-  reverse direction: go forward toward more recent commands
# Both share state — you can freely alternate between them.
# alt+,  after alt+./-, cycle through words of the SAME command (wraps around)

_insert-last-word-direction() {
  if [[ $KEYS == $'\e-' ]]; then
    zle .insert-last-word 1
  else
    zle .insert-last-word -- -1
  fi
}
zle -N insert-last-word _insert-last-word-direction
bindkey '^[-' insert-last-word

_copy-earlier-word-cycling() {
  emulate -L zsh
  typeset -g __cew_index __cew_widget

  if [[ -n $__cew_index && $WIDGET == $LASTWIDGET ]]; then
    (( __cew_index-- ))
  elif [[ $LASTWIDGET == *insert-last-word ]]; then
    __cew_index=-2
    __cew_widget=$LASTWIDGET
  else
    __cew_index=-1
  fi

  # Try inserting; if it fails (past first word), wrap to last word (-1)
  if ! zle ${__cew_widget:-.insert-last-word} 0 $__cew_index 2>/dev/null; then
    __cew_index=-1
    zle ${__cew_widget:-.insert-last-word} 0 $__cew_index
  fi
}
zle -N copy-earlier-word _copy-earlier-word-cycling
bindkey '^[,' copy-earlier-word

alias micromamba=conda

ulimit -n 65535
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH

export HISTSIZE=10000000
export SAVEHIST=10000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS

export GOPATH="$HOME/.go"

path_prepend "$HOME/.asdf/shims" "${GOPATH:-$HOME/.go}/bin" "${KREW_ROOT:-$HOME/.krew}/bin" "$HOME/.local/bin"

test -s "${HOME}/.zsh.after.local" && source "${HOME}/.zsh.after.local"

path_prepend "$HOME/bin"

# activate .venv if exists in current directory or any parent directory
# put this at the end of .zshrc to ensure it runs after all other configurations
activate
