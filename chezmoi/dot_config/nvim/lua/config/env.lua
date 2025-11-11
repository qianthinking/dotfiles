local M = {}

local ssh_markers = { "SSH_TTY", "SSH_CONNECTION", "SSH_CLIENT" }

function M.is_ssh()
  for _, name in ipairs(ssh_markers) do
    local value = vim.env[name]
    if value and value ~= "" then
      return true
    end
  end
  return false
end

function M.has_system_clipboard()
  return vim.fn.has("clipboard") == 1
end

return M
