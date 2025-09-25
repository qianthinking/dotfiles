function __find_upward_venv_dir() {
  local env_name="${1:-.venv}"
  local dir="${2:-$PWD}"

  while true; do
    if [[ -f "$dir/$env_name/bin/activate" ]]; then
      printf '%s\n' "$dir/$env_name"
      return 0
    fi

    if [[ "$dir" == "$HOME" || "$dir" == "/" ]]; then
      break
    fi

    dir=$(dirname "$dir")
  done

  return 1
}

function activate() {
  local env_name="${1:-.venv}"
  local target_env

  if target_env=$(__find_upward_venv_dir "$env_name"); then
    source "$target_env/bin/activate"
  fi
}

function chpwd() {
  local env_name=".venv"
  local target_env

  if target_env=$(__find_upward_venv_dir "$env_name"); then
    if [[ "$VIRTUAL_ENV" == "$target_env" ]]; then
      return 0
    fi

    if [[ -n "$VIRTUAL_ENV" ]] && typeset -f deactivate >/dev/null 2>&1; then
      deactivate 2>/dev/null || true
    fi

    source "$target_env/bin/activate"
    return 0
  fi

  if [[ -n "$VIRTUAL_ENV" ]] && typeset -f deactivate >/dev/null 2>&1; then
    deactivate 2>/dev/null || true
  fi
}
