# =================================================================
# Homebrew Configuration (macOS specific)
# =================================================================
#
# Detects if the OS is macOS, then sets and exports the correct
# Homebrew path for Apple Silicon or Intel architectures.
# The exported HOMEBREW_PREFIX variable is available to the current shell
# and all its child processes.

if [[ "$OSTYPE" == "darwin"* ]]; then
  # We are on macOS, now determine the architecture for Homebrew
  if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon Mac
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    # Intel Mac
    export HOMEBREW_PREFIX="/usr/local"
  fi
  path_prepend "$HOMEBREW_PREFIX/bin"
fi
