# you can disable this by exporting K8S_CONTEXT_NAMESPACE_ENV=disabled in .zshrc

# see zsh/prezto-themes/prompt_qianthinking_setup which
# ensure K8S_CONTEXT && K8S_NAMESPACE exists in SHELL PROMPT
if [ ! "$K8S_CONTEXT_NAMESPACE_ENV" = 'disabled' ]
then
  function kubectl() {
    # Completion requests: pass --context AFTER __complete (kubectl requires this order)
    if [[ "$1" == __complete* ]]; then
      if [ -n "$K8S_CONTEXT" ]; then
        command kubectl "$1" --context "$K8S_CONTEXT" "${@:2}"
      else
        command kubectl "$@"
      fi
      return
    fi

    if [ -z "$K8S_CONTEXT" ]; then
      command kubectl "$@"
      return
    fi

    local extra_args=(--context "$K8S_CONTEXT")

    # Check if user already provided -n or --namespace
    if [ -n "$K8S_NAMESPACE" ]; then
      local has_ns=false
      for arg in "$@"; do
        case "$arg" in
          -n|--namespace|--namespace=*) has_ns=true; break ;;
        esac
      done
      if [ "$has_ns" = false ]; then
        extra_args+=(-n "$K8S_NAMESPACE")
      fi
    fi

    command kubectl "${extra_args[@]}" "$@"
  }
  function kbc() {
    export K8S_CONTEXT=$1
  }

  function kbn() {
    export K8S_NAMESPACE=$1
  }

  function kbclear() {
    export K8S_CONTEXT=''
    export K8S_NAMESPACE=''
  }
fi

