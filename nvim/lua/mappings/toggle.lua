local map = vim.keymap.set

-- indentLine
map("n", "ti", function()
  require("ibl").setup_buffer(0, {
    enabled = not require("ibl.config").get_config(0).enabled,
  })
end, { silent = true })
map("n", "tl", ":AnsiEsc<CR>", { silent = true })
map("n", "tn", ":NvimTreeToggle<CR>", { silent = true })

-- Telescope
map("n", "tt", ":Telescope resume<CR>", { silent = true })

-- Aeral
map("n", "to", ":Lspsaga outline<CR>", { silent = true })
map("n", "ta", ":AvanteToggle<CR>", { silent = true })

-- Keybinding to toggle inlay hints
map("n", "th", function() require("lsp-inlayhints").toggle() end, { silent = true })

-- 快捷键：切换诊断功能的开关
map("n", "td", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
    vim.notify("已禁用诊断功能", vim.log.levels.INFO)
  else
    vim.diagnostic.enable()
    vim.notify("已启用诊断功能", vim.log.levels.INFO)
  end
end, { silent = true })
