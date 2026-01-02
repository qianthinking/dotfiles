#!/bin/sh
# set -e: 如果任何命令返回非零退出状态，脚本将立即退出
set -e

# 检查 bun 命令是否已经存在
if command -v bun >/dev/null 2>&1; then
  echo "bun is already installed."
else
  echo "Installing bun (fast JavaScript runtime)..."
  # 从官方推荐的地址下载并执行安装脚本
  # 默认安装到 $HOME/.bun
  if command -v curl >/dev/null; then
    curl -fsSL https://bun.sh/install | bash
  elif command -v wget >/dev/null; then
    wget -qO - https://bun.sh/install | bash
  else
    echo "To install bun, you must have curl or wget installed." >&2
    exit 1
  fi

  echo "bun installation complete."
  echo "Please ensure '$HOME/.bun/bin' is in your PATH."
  echo "You may need to restart your shell for the changes to take effect."
fi
