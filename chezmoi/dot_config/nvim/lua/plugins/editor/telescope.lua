return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",                -- 必须依赖
            "nvim-telescope/telescope-fzy-native.nvim", -- 模糊匹配性能提升
            "nvim-telescope/telescope-live-grep-args.nvim", -- 为 live_grep 提供参数
        },
        cmd = "Telescope", -- 按需加载，在执行 :Telescope 时加载插件
        config = function()
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')

            local search_tool, search_args

            if vim.fn.executable("rg") == 1 then
                -- 优先使用 ripgrep
                search_tool = "rg"
                search_args = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--line-number",
                    "--column",
                    "--smart-case",
                }
            elseif vim.fn.executable("ag") == 1 then
                -- 如果没有 ripgrep，尝试使用 ag
                search_tool = "ag"
                search_args = {
                    "ag",
                    "--nocolor",
                    "--noheading",
                    "--numbers",
                    "--column",
                    "--smart-case",
                }
            else
                -- 最后回退到 grep
                search_tool = "grep"
                search_args = {
                    "grep",
                    "--color=never",
                    "--no-heading",
                    "--line-number",
                    "--column",
                    "--smart-case",
                }
            end

            -- 提示当前使用的搜索工具
            -- print("Telescope is using: " .. search_tool)

            local function open_or_switch_to_file(prompt_bufnr)
                local selected_entry = action_state.get_selected_entry()

                -- Debug: Print the selected entry value
                -- print("Selected entry value: ", vim.inspect(selected_entry.value))

                -- 如果是 code action 等不涉及文件打开的场景，调用默认行为
                if not selected_entry.value or type(selected_entry.value) ~= "table" or not selected_entry.value.filename then
                  print("Not a file entry, using default behavior.")
                  actions.select_default(prompt_bufnr)  -- 调用默认行为
                  return
                end

                actions.close(prompt_bufnr)

                local file_to_open, line_nr, col_nr

                if type(selected_entry.value) == "table" then
                    -- Handle complex entries (like from live_grep)
                    file_to_open = selected_entry.value.filename or selected_entry.value[1]
                    line_nr = selected_entry.value.lnum
                    col_nr = selected_entry.value.col or 0
                else
                    -- Handle simple file paths and extract line/column if included
                    local match = {string.match(selected_entry.value, "^(.+):(%d+):(%d+):")}

                    -- Debug: Print the match result
                    if #match > 0 then
                        print("Match result: ", vim.inspect(match))
                        file_to_open, line_nr, col_nr = match[1], tonumber(match[2]), tonumber(match[3])
                    else
                        print("No match found.")
                        -- If only the file path is present (no line or column numbers)
                        file_to_open = selected_entry.value
                        line_nr, col_nr = 1, 0  -- Default to the first line and column
                    end
                end

                -- Debug: Print the file to open and the cursor position
                print("File to open: ", file_to_open)
                print("Line: ", line_nr, " Column: ", col_nr)

                if file_to_open then
                    for tab = 1, vim.fn.tabpagenr('$') do
                        local win_found = false
                        local buflist = vim.fn.tabpagebuflist(tab)  -- Get the list of buffers in the tab
                        for win_nr = 1, #buflist do
                            local bufnr = buflist[win_nr]  -- Get the buffer number for this window
                            if vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p") == vim.fn.fnamemodify(file_to_open, ":p") then
                                -- If the file is found in this window, switch to the correct tab and window
                                vim.cmd(tab .. 'tabnext')  -- Activate the correct tab
                                local win_id = vim.fn.win_getid(win_nr)  -- Get the window ID for the current window number
                                vim.fn.win_gotoid(win_id)  -- Activate the correct window

                                -- Set the cursor to the specified line and column
                                if line_nr and col_nr then
                                    vim.api.nvim_win_set_cursor(0, {line_nr, col_nr})
                                end
                                win_found = true
                                break
                            end
                        end
                        if win_found then
                            return
                        end
                    end

                    -- If the file is not already open, open it
                    vim.cmd('edit ' .. vim.fn.fnameescape(file_to_open))
                    -- Set the cursor to the specified line and column
                    if line_nr and col_nr then
                        vim.api.nvim_win_set_cursor(0, {line_nr, col_nr})
                    end
                end
            end

            local builtin = require('telescope.builtin')
            local telescope = require('telescope')


            local lga_actions = require("telescope-live-grep-args.actions")

            local function find_files_with_hidden(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local current_prompt = current_picker:_get_prompt()

                -- 直接调用 find_files 并启用 hidden 选项
                builtin.find_files({
                    hidden = true,
                    no_ignore = true,
                    prompt_title = "Find Files (including hidden)",
                    default_text = current_prompt, -- 保留当前输入内容
                })
            end

            local function safe_quote_with_params(opts)
              opts = opts or {}
              return function(prompt_bufnr)
                -- 获取当前输入内容
                local prompt = action_state.get_current_line()

                -- 分离查询和参数部分
                local query, params = prompt:match('^(.*%S)%s*(.*)$')
                if not query then
                  query = prompt
                  params = ""
                end

                -- 检查查询部分是否已经被引号包围
                local is_quoted = query:match('^%b""') or query:match("^%b''")

                -- 如果查询部分没有被引号包围，则添加双引号
                if not is_quoted then
                  query = '"' .. query .. '"'
                end

                -- 重新组合查询和参数，并添加后缀
                local new_prompt = query .. " " .. params .. (opts.postfix or "")

                -- 设置新的 prompt 值
                local picker = action_state.get_current_picker(prompt_bufnr)
                picker:reset_prompt(new_prompt)
              end
            end

            require('telescope').setup({
                defaults = {
                    vimgrep_arguments = search_args, -- 动态设置搜索工具
                    mappings = {
                        i = {
                            ["<CR>"] = open_or_switch_to_file,
                            ["<c-h>"] = find_files_with_hidden,
                        },
                    },
                    prompt_prefix = "🔍 ",
                    selection_caret = "➤ ",
                    file_ignore_patterns = { "node_modules", ".git" },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
                extensions = {
                    fzy_native = {
                        override_generic_sorter = true,
                        override_file_sorter = true,
                    },
                    live_grep_args = {
                      auto_quoting = false,
                      mappings = {
                        i = {
                          ["<C-k>"] = lga_actions.quote_prompt(),
                          ["<C-h>"] = safe_quote_with_params({ postfix = " --hidden " }),
                          ["<C-g>"] = safe_quote_with_params({ postfix = " --iglob " }),
                        },
                      },
                    },
                },
            })

            telescope.load_extension('fzy_native')

            telescope.load_extension("live_grep_args")

            -- Telescope 的快捷键绑定

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { silent = true })
            -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { silent = true })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { silent = true })
            vim.keymap.set('n', '<leader>fh', function()
                builtin.find_files({
                    hidden = true,
                    no_ignore = true,
                })
            end, { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>fp', builtin.help_tags, { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>fe', builtin.diagnostics, { noremap = true, silent = true }) -- 显示所有诊断信息
            vim.keymap.set('n', 'got', builtin.lsp_type_definitions, { noremap = true, silent = true }) -- 跳转到类型定义
            vim.keymap.set('n', 'gi', builtin.lsp_implementations, { noremap = true, silent = true }) -- 跳转到实现
            vim.keymap.set('n', 'gr', builtin.lsp_references, { noremap = true, silent = true }) -- 查看引用
            vim.keymap.set('n', 'gd', builtin.lsp_definitions, { noremap = true, silent = true }) -- 跳转到定义

            -- 在新标签页中打开定义的自定义函数
            local function lsp_definitions_in_new_tab()
                -- 先保存当前位置到jumplist
                vim.cmd('normal! m`')

                -- 获取定义列表
                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx)
                    if err or not result or vim.tbl_isempty(result) then
                        print("No definitions found")
                        return
                    end

                    -- 如果只有一个定义，直接在新标签页打开
                    if #result == 1 then
                        local definition = result[1]
                        local uri = definition.uri or definition.targetUri
                        local range = definition.range or definition.targetRange or definition.targetSelectionRange

                        if uri then
                            local filepath = vim.uri_to_fname(uri)
                            vim.cmd('tabnew ' .. vim.fn.fnameescape(filepath))

                            if range and range.start then
                                local line = range.start.line + 1
                                local col = range.start.character
                                vim.api.nvim_win_set_cursor(0, {line, col})
                            end
                        end
                    else
                        -- 如果有多个定义，使用telescope但在新标签页打开选中的项
                        builtin.lsp_definitions({
                            attach_mappings = function(prompt_bufnr, map)
                                map('i', '<CR>', function()
                                    local selected_entry = action_state.get_selected_entry()
                                    actions.close(prompt_bufnr)

                                    if selected_entry and selected_entry.filename then
                                        vim.cmd('tabnew ' .. vim.fn.fnameescape(selected_entry.filename))
                                        if selected_entry.lnum then
                                            vim.api.nvim_win_set_cursor(0, {selected_entry.lnum, selected_entry.col or 0})
                                        end
                                    end
                                end)
                                return true
                            end
                        })
                    end
                end)
            end

            vim.keymap.set('n', 'gt', lsp_definitions_in_new_tab, { noremap = true, silent = true, desc = "Go to definition in new tab" })
            vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { noremap = true, silent = true }) -- 显示当前文档的符号
            vim.keymap.set('n', '<leader>fw', builtin.lsp_dynamic_workspace_symbols, { noremap = true, silent = true }) -- 显示工作区符号

            vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { silent = true })
            local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
            vim.keymap.set("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor)
            vim.keymap.set("v", "<leader>fc", live_grep_args_shortcuts.grep_visual_selection)


            --[[ local live_grep_args = require("telescope").extensions.live_grep_args ]]
            --[[ -- Visual mode mapping to grep for the selected text ]]
            --[[ vim.keymap.set('v', '<leader>fc', function() ]]
            --[[     -- Ensure the visual mode is properly registered before retrieving the selection ]]
            --[[     vim.cmd('normal! "vy')  -- Yank the current visual selection into register 'v' ]]
            --[[]]
            --[[     local selection = vim.fn.getreg('v') ]]
            --[[]]
            --[[     -- Ensure that the selection is non-empty ]]
            --[[     if selection and #selection > 0 then ]]
            --[[         -- Quote the selection ]]
            --[[         local quoted_selection = '"' .. selection:gsub('"', '\\"') .. '"' ]]
            --[[]]
            --[[         -- Use live_grep_args with the quoted text and -F parameter ]]
            --[[         live_grep_args.live_grep_args({ ]]
            --[[             default_text = quoted_selection, ]]
            --[[             additional_args = function() ]]
            --[[                 return { "-F" } ]]
            --[[             end, ]]
            --[[         }) ]]
            --[[     else ]]
            --[[         print("No text selected.") ]]
            --[[     end ]]
            --[[ end, { noremap = true, silent = true }) ]]
        end,
    },
}
