local map = vim.keymap.set

-- indentLine
map("n", "ti", function()
  require("ibl").setup_buffer(0, {
    enabled = not require("ibl.config").get_config(0).enabled,
  })
end, { silent = true })
map("n", "tl", ":AnsiEsc<CR>", { silent = true })
map("n", "tn", ":NvimTreeToggle<CR>", { silent = true })

-- nvim-treesitter-context
map("n", "tc", ":TSContext toggle<CR>", { silent = true })

-- Telescope
map("n", "tt", ":Telescope resume<CR>", { silent = true })

-- Outline (prefer Lspsaga; fallback to Aerial)
map("n", "to", function()
  local clients
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients({ bufnr = 0 })
  else
    clients = vim.lsp.get_active_clients({ bufnr = 0 })
  end

  local has_symbols = false
  for _, client in ipairs(clients or {}) do
    local caps = client.server_capabilities or client.resolved_capabilities or {}
    if caps.documentSymbolProvider or caps.document_symbol then
      has_symbols = true
      break
    end
  end

  if has_symbols then
    vim.cmd("Lspsaga outline")
  else
    vim.cmd("AerialToggle")
  end
end, { silent = true, desc = "Toggle outline (Saga/Aerial)" })
map("n", "ta", ":AvanteToggle<CR>", { silent = true })

-- Keybinding to toggle inlay hints (built-in API, works with basedpyright)
map("n", "th", function()
  -- check server capability first to avoid confusing no-ops
  local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 }) or vim.lsp.get_active_clients({ bufnr = 0 })
  local has_inlay = false
  for _, c in ipairs(clients or {}) do
    local caps = c.server_capabilities or {}
    if caps.inlayHintProvider then
      has_inlay = true
      break
    end
  end
  if not has_inlay then
    vim.notify("No LSP inlayHintProvider available for this buffer", vim.log.levels.WARN)
    return
  end

  local ih = vim.lsp.inlay_hint
  local buf = 0
  if type(ih) == "table" and ih.enable and ih.is_enabled then
    local enabled = ih.is_enabled({ bufnr = buf })
    ih.enable(not enabled, { bufnr = buf })
  elseif type(ih) == "function" then
    -- Neovim 0.9 compatibility: toggles when second arg is nil
    ih(buf, nil)
  else
    vim.notify("Inlay hint API not available in this Neovim version", vim.log.levels.WARN)
    return
  end
end, { silent = true, desc = "Toggle inlay hints" })

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

-- Toggle Copilot suggestion
map("n", "ts", function()
  require("copilot.suggestion").toggle_auto_trigger()
  vim.notify("Copilot auto trigger toggled", vim.log.levels.INFO)
end, { silent = true, desc = "Toggle Copilot suggestion" })
