return {
  {
    "ojroques/nvim-osc52",
    config = function()
      local osc52 = require("osc52")
      osc52.setup({
        max_length = 0,       -- 0 为不限制（有些终端/SSH 会有限制，默认就好）
        silent = true,
        trim = false,
      })

      -- 将系统寄存器写入钩到 OSC52
      local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
      end

      -- OSC52 主要用于远程环境的复制
      -- 本地环境让 Neovim 使用默认的系统剪贴板
      if os.getenv("SSH_TTY") then
        local function paste()
          return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
        end

        vim.g.clipboard = {
          name = 'osc52',
          copy = {['+'] = copy, ['*'] = copy},
          paste = {['+'] = paste, ['*'] = paste},
        }
      end

      -- 常见设置：使用系统剪贴板
      vim.opt.clipboard = "unnamedplus"
    end,
  }
}
