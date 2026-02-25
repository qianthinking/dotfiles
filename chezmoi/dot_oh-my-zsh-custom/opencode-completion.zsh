# Completion for OpenCode CLI
# Generated once and committed to chezmoi. Regenerate with:
#   opencode completion zsh > ~/.oh-my-zsh-custom/opencode-completion.zsh

_opencode_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
compdef _opencode_yargs_completions opencode
