return {
    {
        "Shatur/neovim-session-manager",
        cond = not vim.g.vscode, -- Load only if not in VSCode
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local Path = require("plenary.path")
            local session_manager = require("session_manager")
            local sm_config = require("session_manager.config")

            -- 使用默认 sessions_dir（单一目录），避免跨项目回退
            session_manager.setup({
                autoload_mode = sm_config.AutoloadMode.Disabled, -- 我们自行控制何时自动加载
                autosave_last_session = false, -- 禁用全局 last session 回退
                autosave_ignore_filetypes = { "gitcommit", "gitrebase", "gitconfig" },
            })

            -- 以 CWD 为键的会话文件: <stdpath('data')>/sessions/<sanitized_cwd>.vim
            local function sessions_root()
                local p = Path:new(vim.fn.stdpath("data"), "sessions")
                p:mkdir({ parents = true, exist_ok = true })
                return p
            end

            local function sanitize_dir(dir)
                return dir:gsub("[/:\\]", "_")
            end

            local function session_file_for_cwd()
                local name = sanitize_dir(vim.fn.getcwd()) .. ".vim"
                return Path:new(sessions_root(), name).filename
            end

            -- 启动时：仅当当前目录存在会话，且未传入文件参数时才加载
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = function()
                    if vim.g.vscode then return end
                    -- 允许 nvim 或 nvim . 自动加载（目录参数也视为无文件参数）
                    if vim.fn.argc() > 0 then
                        if not (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1) then
                            return
                        end
                    end
                    local file = session_file_for_cwd()
                    if vim.loop.fs_stat(file) then
                        vim.cmd("silent! source " .. vim.fn.fnameescape(file))
                        -- Re-apply colorscheme and ensure highlights/plugins attach after restore
                        vim.schedule(function()
                            pcall(vim.cmd, "silent! colorscheme nordfox")
                            -- Ensure Treesitter attaches (if available)
                            local ok_ts = pcall(require, "nvim-treesitter.configs")
                            if ok_ts and vim.treesitter and vim.treesitter.start then
                                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
                                        pcall(vim.treesitter.start, buf)
                                    end
                                end
                            else
                                -- Fallback: trigger BufReadPost for each listed buffer
                                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
                                        pcall(vim.api.nvim_exec_autocmds, "BufReadPost", { buffer = buf, modeline = false })
                                    end
                                end
                            end
                        end)
                    end
                end,
            })

            -- 退出前自动保存当前目录会话（仅包含当前 CWD 下的普通文件）
            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    if vim.g.vscode then return end

                    local cwd = vim.fn.getcwd()
                    if cwd == "" then
                        return
                    end
                    local cwd_prefix = vim.fn.fnamemodify(cwd, ":p")
                    if not cwd_prefix:match("/$") then
                        cwd_prefix = cwd_prefix .. "/"
                    end

                    -- 过滤掉不在当前 CWD 下的普通文件 buffer，避免跨目录 session 污染
                    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
                            local name = vim.api.nvim_buf_get_name(bufnr)
                            if name ~= "" then
                                local abs = vim.fn.fnamemodify(name, ":p")
                                if not vim.startswith(abs, cwd_prefix) then
                                    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
                                end
                            end
                        end
                    end

                    local file = session_file_for_cwd()
                    sessions_root():mkdir({ parents = true, exist_ok = true })
                    vim.cmd("silent! mksession! " .. vim.fn.fnameescape(file))
                end,
            })
        end,
    },
}
