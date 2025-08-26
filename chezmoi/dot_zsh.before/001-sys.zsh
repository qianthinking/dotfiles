# Prepend directories to PATH with uniqueness in zsh
path_prepend() {
  local dir
  for dir in "$@"; do
    [[ -n $dir ]] || continue
    path=(${path:#$dir})      # Remove directory if it exists
    path=("$dir" $path)       # Prepend to front
  done
  typeset -gU path            # Apply uniqueness after modifications
}

