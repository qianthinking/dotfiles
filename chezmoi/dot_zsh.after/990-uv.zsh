function activate() {
  local env_name="${1:-.venv}"
  local dir="$PWD"
  local tried_home=0

  while true; do
    if [[ -f "$dir/$env_name/bin/activate" ]]; then
      source "$dir/$env_name/bin/activate"
      return 0
    fi

    # 一旦到达 $HOME，尝试一次，之后不再查找
    if [[ "$dir" == "$HOME" ]]; then
      tried_home=1
    fi

    # 退出条件：到达根目录，或已经尝试过 $HOME
    if [[ "$dir" == "/" || $tried_home -eq 1 ]]; then
      break
    fi

    dir=$(dirname "$dir")
  done
}

function chpwd() {
  if [[ -d ".venv" ]]; then
    # 若有虚拟环境则先尝试 deactivate
    deactivate 2>/dev/null || true
    activate
  fi
}

# put this at the end of .zshrc to ensure it runs after all other configurations
activate
