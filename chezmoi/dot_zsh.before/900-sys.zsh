# Prepend directories to PATH with uniqueness in zsh
path_prepend() {
  typeset -gU path          # 只对数组 path 设 unique；第一次调用才生效
  local dir
  for dir in "$@"; do
    [[ -n $dir ]] || continue
    path=("$dir" ${path:#$dir})
  done
}

path_prepend "$HOME/bin" "$HOME/.local/bin" "$HOMEBREW_PREFIX/bin"

test -s "${HOME}/.zsh.before.local" && source "${HOME}/.zsh.before.local"
