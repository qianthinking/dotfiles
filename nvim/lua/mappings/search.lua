local map = vim.keymap.set

map("n", "//", ":nohlsearch<CR>", { silent = true })
map("n", ",hl", ":set hlsearch! hlsearch?<CR>", { silent = true })

-- Open a file in a new vertical split
map("n", ",gf", ":vertical botright wincmd F<CR>", { silent = true })


-- 文件路径相关快捷键
map("n", ",cd", ':let @* = expand("%:h")<CR>', { silent = true })
map("n", ",cf", ':let @* = expand("%:p")<CR>', { silent = true })
map("n", ",ch", ':let @* = expand("%:~")<CR>', { silent = true })
map("n", ",cr", ':let @* = expand("%:.")<CR>', { silent = true })
map("n", ",cn", ':let @* = expand("%:t")<CR>', { silent = true })

-- 跳转到下一个诊断
map('n', '<leader>dn', function()
  vim.diagnostic.goto_next()
end, { silent = true, desc = "Go to next diagnostic" })

-- 跳转到上一个诊断
map('n', '<leader>dp', function()
  vim.diagnostic.goto_prev()
end, { silent = true, desc = "Go to previous diagnostic" })

-- 跳转到下一个错误
map('n', '<leader>en', function()
  vim.diagnostic.goto_next({
    severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR }
  })
end, { silent = true, desc = "Go to next error" })

-- 跳转到上一个错误
map('n', '<leader>ep', function()
  vim.diagnostic.goto_prev({
    severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR }
  })
end, { silent = true, desc = "Go to previous error" })
