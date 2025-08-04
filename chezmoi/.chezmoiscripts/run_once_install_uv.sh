#!/bin/sh
# set -e: 如果任何命令返回非零退出状态，脚本将立即退出
set -e

# 检查 uv 命令是否已经存在
if command -v uv >/dev/null 2>&1; then
  echo "uv is already installed."
else
  echo "Installing uv (fast Python package installer)..."
  # 从官方推荐的地址下载并执行安装脚本
  # 这个脚本会自动检测操作系统和架构，并安装到 $HOME/.cargo/bin
  # 它也会提示用户将该目录添加到 PATH，但我们的 zshrc 配置应该已经处理了
  if command -v curl >/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  elif command -v wget >/dev/null; then
    wget -qO - https://astral.sh/uv/install.sh | sh
  else
    echo "To install uv, you must have curl or wget installed." >&2
    # 返回非零状态，如果 chezmoi 配置为严格模式，可能会停止
    exit 1
  fi

  echo "uv installation complete."
  echo "Please ensure '$HOME/.cargo/bin' is in your PATH."
  echo "You may need to restart your shell for the changes to take effect."
fi
