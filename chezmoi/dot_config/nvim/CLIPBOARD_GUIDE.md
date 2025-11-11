# Neovim 剪贴板配置说明

## 当前配置

你的 Neovim 配置已经针对不同环境进行了优化：

### 1. 本地环境（非SSH）
- **clipboard=unnamedplus** 启用
- 使用系统剪贴板（`pbcopy`/`pbpaste` on macOS）
- `yy` 自动复制到系统剪贴板
- `p` 从系统剪贴板粘贴

### 2. 远程 SSH + tmux 环境
- **clipboard=unnamedplus** 禁用（避免冲突）
- 使用 **默认寄存器** 进行正常 yank/paste 操作
- **OSC52 插件** 自动同步所有 yank 操作到本地剪贴板
- `yy` → 复制到默认寄存器 + 通过 OSC52 同步到本地剪贴板
- `p` → 从默认寄存器粘贴
- `"+y` → 显式复制到剪贴板寄存器（如果需要）

## 远程环境的工作流程

### 复制（从远程到本地）
1. 在 Neovim 中使用 `yy` 或其他 yank 命令
2. 文本保存到默认寄存器（`"`）
3. OSC52 插件自动将内容发送到**本地系统剪贴板**
4. 可以在本地任何地方粘贴（Cmd+V / Ctrl+V）

### 粘贴（在远程环境内）
1. 使用 `yy` 复制
2. 使用 `p` 粘贴 - **现在可以正常工作了！**
3. 无需依赖系统剪贴板或 tmux 缓冲区

## 配置更改说明

### 修复的问题
在远程 SSH + tmux 环境中，`yy` 后立即 `p` 会报错 "E353: Nothing in the register"

### 根本原因
1. `clipboard=unnamedplus` 会将所有 yank 操作重定向到 `+` 寄存器
2. 在 SSH 环境中，`+` 寄存器没有有效的 clipboard 提供者
3. 导致默认寄存器 `"` 没有被填充

### 解决方案
1. **SSH 环境**：禁用 `clipboard=unnamedplus`
   - 正常 yank/paste 使用默认寄存器
   - OSC52 通过 `TextYankPost` autocmd 自动同步到本地
2. **本地环境**：保持 `clipboard=unnamedplus`
   - 直接使用系统剪贴板

## 故障排查

### 测试剪贴板提供者
在 Neovim 中运行：
```vim
:echo g:clipboard
```

### 测试 tmux 缓冲区
在 tmux 中：
```bash
# 查看 tmux 缓冲区
tmux show-buffer

# 手动设置 tmux 缓冲区
echo "test content" | tmux load-buffer -

# 手动从 tmux 缓冲区读取
tmux save-buffer -
```

### 测试 OSC52
在远程服务器运行：
```bash
echo $SSH_TTY  # 应该显示 tty 设备路径
```

### 检查 Neovim 寄存器
在 Neovim 中：
```vim
:reg  " 查看所有寄存器
:reg +  " 查看系统剪贴板寄存器
```

## 如果还是不工作

1. **确保重启了 Neovim**：`:source $MYVIMRC`

2. **检查 tmux 版本**：`tmux -V`（建议 3.0+）

3. **确保终端支持 OSC52**：
   - iTerm2：✅ 默认支持
   - Terminal.app：⚠️ 部分支持
   - Kitty：✅ 完全支持
   - Alacritty：✅ 完全支持

4. **添加 tmux 配置**（如果还没有）：
   ```bash
   # 在 ~/.tmux.conf 中
   set -g set-clipboard on
   set -g default-terminal "screen-256color"
   set -ag terminal-overrides "vte*:XT:Ms=\\E]52;c;%p2%s\\7,xterm*:XT:Ms=\\E]52;c;%p2%s\\7"
   ```

5. **使用显式粘贴键位**（添加到 Neovim 配置）：
   ```lua
   -- 显式从 tmux 缓冲区粘贴
   vim.keymap.set('n', '<leader>p', function()
     local content = vim.fn.system('tmux save-buffer -')
     vim.api.nvim_put({content}, 'c', true, true)
   end, { desc = 'Paste from tmux buffer' })
   ```
