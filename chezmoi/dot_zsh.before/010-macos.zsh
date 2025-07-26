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

  # Add Homebrew's zsh completions to fpath.
  fpath=($HOMEBREW_PREFIX/share/zsh/functions $HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

  # Set up Homebrew environment variables (PATH, etc.) if brew is installed.
  if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  fi

  # Add GNU coreutils to PATH if installed via Homebrew
  GNU_PACKAGE_PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  if [ -d "$GNU_PACKAGE_PATH" ]; then
    export PATH="$GNU_PACKAGE_PATH:$PATH"
  fi

  if [ -d "$HOMEBREW_PREFIX/opt/mysql-client/bin" ]; then
    # Add MySQL client binaries to PATH if installed via Homebrew
    # This is useful for accessing MySQL commands like `mysql`, `mysqldump`, etc.
    export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"
  fi

  test -d "$HOMEBREW_PREFIX/opt/openssl@1.1" && export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@1.1"

  if [ -f "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
  fi
fi
