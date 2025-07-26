test -s "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -s "${HOME}/.scm_breeze/scm_breeze.sh" && source "${HOME}/.scm_breeze/scm_breeze.sh"
test -s "${HOME}/.config/broot/launcher/bash/br" && source "${HOME}/.config/broot/launcher/bash/br"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"


export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1

# =================================================================
# PNPM Configuration (Robust Cross-Platform Version)
# =================================================================
#
# Detects the default pnpm installation and adds it to the PATH
# only if it actually exists.

# Define a temporary variable for the potential pnpm path
local pnpm_home_path=""

# Determine the default pnpm home directory based on the OS.
if [[ "$OSTYPE" == "darwin"* ]]; then
  pnpm_home_path="$HOME/Library/pnpm" # macOS path
else
  pnpm_home_path="$HOME/.local/share/pnpm" # Linux/other path
fi

# Check if the directory exists before modifying the environment
if [ -d "$pnpm_home_path" ]; then
  export PNPM_HOME="$pnpm_home_path"

  # Add to PATH if not already present
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

# Clean up the temporary variable
unset pnpm_home_path

test -s "${HOME}/.zsh.after.local" && source "${HOME}/.zsh.after.local"
