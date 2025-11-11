-- Clipboard diagnostic script
print("=== Neovim Clipboard Diagnostic ===")
print("TMUX env: " .. (vim.env.TMUX or "not set"))
print("Clipboard option: " .. vim.inspect(vim.opt.clipboard:get()))
print("\nClipboard provider info:")
print(vim.inspect(vim.g.clipboard))

print("\nChecking clipboard providers:")
local has_clipboard = vim.fn.has("clipboard")
print("Has clipboard: " .. has_clipboard)

print("\nTesting pbcopy/pbpaste:")
local pbcopy_test = vim.fn.system("which pbcopy")
local pbpaste_test = vim.fn.system("which pbpaste")
print("pbcopy: " .. pbcopy_test)
print("pbpaste: " .. pbpaste_test)

print("\nTesting clipboard write:")
vim.fn.setreg('+', 'test from neovim')
print("Set + register to: 'test from neovim'")

print("\nChecking + register content:")
local content = vim.fn.getreg('+')
print("+ register content: '" .. content .. "'")

print("\nChecking * register content:")
local star_content = vim.fn.getreg('*')
print("* register content: '" .. star_content .. "'")
