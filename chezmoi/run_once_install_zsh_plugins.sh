#!/bin/sh
# set -e: 如果任何命令返回非零退出状态，脚本将立即退出
set -e

# 定义 oh-my-zsh custom 目录
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# 定义插件列表（仓库地址）
ZSH_PLUGINS=(
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting"
  "https://github.com/zsh-users/zsh-completions"
)

echo "Installing/Updating Zsh plugins..."

for plugin_repo in "${ZSH_PLUGINS[@]}"; do
  # 从仓库 URL 中提取插件名称
  plugin_name=$(basename "$plugin_repo")
  target_dir="$ZSH_CUSTOM/plugins/$plugin_name"

  if [ -d "$target_dir" ]; then
    echo "Plugin '$plugin_name' already exists, updating..."
    # 如果目录存在，就更新它
    git -C "$target_dir" pull
  else
    echo "Cloning plugin '$plugin_name'..."
    # 如果目录不存在，就克隆它
    git clone "$plugin_repo" "$target_dir"
  fi
done

echo "Zsh plugins installation/update complete."
