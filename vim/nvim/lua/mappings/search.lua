local map = vim.keymap.set

map("n", "//", ":nohlsearch<CR>", { silent = true })
map("n", ",hl", ":set hlsearch! hlsearch?<CR>", { silent = true })

-- Open a file in a new vertical split
map("n", ",gf", ":vertical botright wincmd F<CR>", { silent = true })


-- 文件路径相关快捷键
map("n", ",cf", ':let @* = expand("%:~")<CR>', { silent = true })
map("n", ",cr", ':let @* = expand("%")<CR>', { silent = true })
map("n", ",cn", ':let @* = expand("%:t")<CR>', { silent = true })

