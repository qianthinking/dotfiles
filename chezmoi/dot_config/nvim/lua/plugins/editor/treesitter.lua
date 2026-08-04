return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "main",
        lazy = false,
        config = function()
            require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "ruby", "java", "go", "html", "css", "javascript", "typescript", "tsx", "json", "yaml", "toml", "regex", "comment", "dockerfile", "rust", "scss", "vue", "nginx" })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
                    if not stats or stats.size <= 100 * 1024 then
                        pcall(vim.treesitter.start, args.buf)
                    end
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                end,
            })
            vim.opt.foldlevelstart = 99

            -- Option+f to move to the next function start
            vim.api.nvim_set_keymap('n', '<A-f>', [[:lua require'nvim-treesitter.textobjects.move'.goto_next_start('@class.outer')<CR>]], { noremap = true, silent = true })

            -- Option+b to move to the previous function start
            vim.api.nvim_set_keymap('n', '<A-b>', [[:lua require'nvim-treesitter.textobjects.move'.goto_previous_start('@class.outer')<CR>]], { noremap = true, silent = true })
            --
            -- Option+f to move to the next function start
            vim.api.nvim_set_keymap('n', '<A-d>', [[:lua require'nvim-treesitter.textobjects.move'.goto_next_start('@function.outer')<CR>]], { noremap = true, silent = true })

            -- Option+b to move to the previous function start
            vim.api.nvim_set_keymap('n', '<A-u>', [[:lua require'nvim-treesitter.textobjects.move'.goto_previous_start('@function.outer')<CR>]], { noremap = true, silent = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "BufReadPost",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move = { set_jumps = true },
            })

            local select = require("nvim-treesitter-textobjects.select")
            for key, capture in pairs({ af = "@function.outer", ["if"] = "@function.inner", ac = "@class.outer", ic = "@class.inner" }) do
                vim.keymap.set({ "x", "o" }, key, function() select.select_textobject(capture, "textobjects") end)
            end

            local move = require("nvim-treesitter-textobjects.move")
            for key, mapping in pairs({
                ["]m"] = { move.goto_next_start, "@function.outer" },
                ["]]"] = { move.goto_next_start, "@class.outer" },
                ["]M"] = { move.goto_next_end, "@function.outer" },
                ["]["] = { move.goto_next_end, "@class.outer" },
                ["[m"] = { move.goto_previous_start, "@function.outer" },
                ["[["] = { move.goto_previous_start, "@class.outer" },
                ["[M"] = { move.goto_previous_end, "@function.outer" },
                ["[]"] = { move.goto_previous_end, "@class.outer" },
            }) do
                vim.keymap.set({ "n", "x", "o" }, key, function() mapping[1](mapping[2], "textobjects") end)
            end

            local swap = require("nvim-treesitter-textobjects.swap")
            vim.keymap.set("n", "<leader>sal", function() swap.swap_next("@parameter.inner") end)
            vim.keymap.set("n", "<leader>sah", function() swap.swap_previous("@parameter.inner") end)
        end,
    },
    {
        "tree-sitter-grammars/tree-sitter-markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require'treesitter-context'.setup{
              enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
              multiwindow = true, -- Enable multiwindow support.
              max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
              min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
              line_numbers = true,
              multiline_threshold = 20, -- Maximum number of lines to show for a single context
              trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
              mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
              -- Separator between context and content. Should be a single character string, like '-'.
              -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
              separator = "-",
              zindex = 20, -- The Z-index of the context window
              on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end,
    },
}
