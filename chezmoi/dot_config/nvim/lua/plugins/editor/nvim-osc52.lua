return {
  {
    "ojroques/nvim-osc52",
    -- 只在 SSH 环境加载此插件
    cond = function()
      return os.getenv("SSH_TTY") ~= nil
    end,
    event = "VeryLazy",
    config = function()
      local osc52 = require("osc52")
      osc52.setup({
        max_length = 0,
        silent = true,
        trim = false,
      })

      -- 远程 yank 时，通过 OSC52 同步到本地剪贴板
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.v.event.operator == 'y' then
            require('osc52').copy(table.concat(vim.v.event.regcontents, '\n'))
          end
        end,
      })
    end,
  }
}
