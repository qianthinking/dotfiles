local map = vim.keymap.set

-- splitjoin
map("n", "gS", ":SplitjoinSplit<CR>", { silent = true })
map("n", "gJ", ":SplitjoinJoin<CR>", { silent = true })

-- vim-easy-align
map("x", "ga", "<Plug>(EasyAlign)", { silent = true })
map("n", "ga", "<Plug>(EasyAlign)", { silent = true })

-- Macro
map("n", "<Space><Space>", "@q", { silent = true })
map("n", "<Space>1", "@1", { silent = true })
map("n", "<Space>2", "@2", { silent = true })

-- Pasting
map("v", "<leader>p", '"0p', { silent = true })
map("v", "<leader>P", '"0P', { silent = true })

map("n", "Y", "y$", { silent = true })

map("n", "0", "^", { silent = true })
map("n", "^", "0", { silent = true })

-- 跳转到最后编辑点
map("n", "<leader>.", "'.", { silent = true })

-- 跳转到更早的编辑点
map("n", "<leader>ge", "g;", { silent = true })

-- 跳转到更晚的编辑点
map("n", "<leader>gl", "g,", { silent = true })

map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })

map("n", "<Space><Space>", "@q", { silent = true })
map("n", "<Space>1", "@1", { silent = true })
map("n", "<Space>2", "@2", { silent = true })

map("i", "<C-l>", " <space>=><space>", { silent = true })
map("c", "<C-l>", " <space>=><space>", { silent = true })
map("i", "<C-g>", " <space>-><space>", { silent = true })
map("c", "<C-g>", " <space>-><space>", { silent = true })

-- clean up trailing whitespaces
map("n", "<leader>cs", ":%s/\\s\\+$//e<CR>", { silent = true })

local builtin = require('telescope.builtin')

map('n', '<leader>wd', builtin.diagnostics, { desc = "Workspace Diagnostics" })
map('n', '<leader>fd', function() builtin.diagnostics({ bufnr = 0 }) end, { desc = "File Diagnostics" })

-- Copy current diagnostic message to clipboard
map("n", "<leader>ce", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics == 0 then
    vim.notify("No diagnostics found at current line", vim.log.levels.INFO)
    return
  end

  -- Get the first diagnostic at current line
  local diagnostic = diagnostics[1]
  local message = diagnostic.message
  local source = diagnostic.source or "unknown"
  local severity = vim.diagnostic.severity[diagnostic.severity] or "UNKNOWN"

  -- Format the diagnostic info
  local diagnostic_info = string.format("[%s] %s: %s", severity, source, message)

  -- Copy to clipboard
  vim.fn.setreg('+', diagnostic_info)
  vim.notify(string.format("Copied diagnostic: %s", diagnostic_info), vim.log.levels.INFO)
end, { silent = true, desc = "Copy current diagnostic to clipboard" })

map("n", "<leader>lr", "<cmd>lua require('lint').try_lint()<CR>", { noremap = true, silent = true, desc = "Run Ruff Lint" })
