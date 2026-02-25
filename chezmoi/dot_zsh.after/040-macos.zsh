# =================================================================
# Homebrew Configuration (macOS specific)
# =================================================================
#
# Detects if the OS is macOS, then sets and exports the correct
# Homebrew path for Apple Silicon or Intel architectures.
# The exported HOMEBREW_PREFIX variable is available to the current shell
# and all its child processes.

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew's site-functions and zsh functions are already in fpath via
  # system defaults (/etc/zshrc). No need to add them again.

  # Set up Homebrew environment variables (PATH, etc.) if brew is installed.
  if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  fi

  # Initialize Atuin shell history manager if installed via Homebrew
  if [ -f "$HOMEBREW_PREFIX/bin/atuin" ]; then
    eval "$($HOMEBREW_PREFIX/bin/atuin init zsh)"
  fi

  # Add GNU coreutils to PATH if installed via Homebrew
  GNU_PACKAGE_PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  if [ -d "$GNU_PACKAGE_PATH" ]; then
    path_prepend $GNU_PACKAGE_PATH
  fi

  if [ -d "$HOMEBREW_PREFIX/opt/mysql-client/bin" ]; then
    # Add MySQL client binaries to PATH if installed via Homebrew
    # This is useful for accessing MySQL commands like `mysql`, `mysqldump`, etc.
    path_prepend "$HOMEBREW_PREFIX/opt/mysql-client/bin"
  fi

  test -d "$HOMEBREW_PREFIX/opt/openssl@1.1" && export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@1.1"

  if [ -f "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down
  fi
fi
