return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
                signcolumn = true, -- 在左侧显示标记列
                numhl      = false, -- 关闭行号高亮
                linehl     = false, -- 关闭整行高亮
                watch_gitdir = {
                    interval = 1000, -- 监控 Git 目录的刷新间隔
                    follow_files = true, -- 追踪文件路径的移动
                },
                attach_to_untracked = true, -- 未追踪文件也启用 gitsigns
                current_line_blame = false, -- 启用当前行的 Git blame 信息
                current_line_blame_opts = {
                    delay = 500, -- 显示延迟
                    virt_text_pos = "eol", -- 在行尾显示
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
                sign_priority = 6, -- 标记优先级
                update_debounce = 200, -- 更新的防抖时间
                status_formatter = nil, -- 使用默认的状态格式化器
                max_file_length = 40000, -- 超过此长度的文件不启用 gitsigns
                preview_config = {
                    border = "rounded", -- 使用圆角边框
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })
            vim.keymap.set("n", "tg", function()
                require("gitsigns").toggle_current_line_blame()
            end, { noremap = true, silent = true, desc = "Toggle Git line blame" })
        end,
    },
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy", -- 或者 cmd = "DiffviewOpen"
        keys = {
          {
            "<leader>gd",
            "<cmd>DiffviewOpen<cr>",
            desc = "打开 Diffview (解决冲突/查看Diff)"
          },
          {
            "<leader>gh",
            "<cmd>DiffviewFileHistory %<cr>",
            desc = "查看当前文件历史"
          },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          local actions = require("diffview.actions")

          require("diffview").setup({
            -- 1. 核心配置：视图布局
            view = {
              -- 普通 Diff 模式下的布局 (git diff)
              default = {
                layout = "diff2_horizontal", -- 左右对比
              },
              -- 解决冲突模式下的布局 (重点在这里)
              merge_tool = {
                -- 布局模式：
                -- "diff1_plain"   : 只有结果窗口
                -- "diff3_horizontal": 左中右 (Local, Base, Remote)，无结果窗口
                -- "diff3_mixed"     : 默认。左(Local) 右(Remote)，下(Result)。 **不显示 Base**
                -- "diff4_mixed"     : 最强模式。上左(Local) 上中(Base) 上右(Remote)，下(Result)
                layout = "diff4_mixed",

                disable_diagnostics = true, -- 解决冲突时关闭 LSP 报错，防止红线干扰
              },
              file_history = {
                layout = "diff2_horizontal",
              },
            },

            -- 2. 快捷键配置 (根据习惯修改)
            keymaps = {
              view = {
                -- 在 diff 视图中，快速关闭
                ["q"] = actions.close,
                ["<Esc>"] = actions.close,
              },
              file_panel = {
                ["q"] = actions.close,
              },
              file_history_panel = {
                ["q"] = actions.close,
              }
            },
          })
        end,
    }
}
