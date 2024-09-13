local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function open_or_switch_to_file(prompt_bufnr)
    local selected_entry = action_state.get_selected_entry()

    local file_to_open
    local line_nr
    if type(selected_entry.value) == "table" then
        -- Handle complex entries (like from live_grep)
        file_to_open = selected_entry.value.filename or selected_entry.value[1]
        line_nr = selected_entry.value.lnum
    else
        -- Handle simple file paths
        file_to_open = selected_entry.value
    end

    -- Check if file_to_open is nil
    if file_to_open then
        -- Check if the file is already open in a tab
        for tab = 1, vim.fn.tabpagenr('$') do
            for _, bufnr in ipairs(vim.fn.tabpagebuflist(tab)) do
                if vim.fn.bufname(bufnr) == file_to_open then
                    vim.cmd(tab .. 'tabnext')
                    vim.cmd('buffer ' .. bufnr)
                    if line_nr then
                        vim.api.nvim_win_set_cursor(0, {line_nr, 0})
                    end
                    return
                end
            end
        end

        -- Use the default Telescope action to open the file (without closing the picker early)
        actions.select_default(prompt_bufnr)

        -- Optionally go to the specific line if it's available
        if line_nr then
            vim.api.nvim_win_set_cursor(0, {line_nr, 0})
        end
    else
        -- Custom handling, then close the picker manually
        if selected_entry.value.name then
            vim.fn.feedkeys(':' .. selected_entry.value.name)
        else
            vim.notify(vim.inspect(selected_entry.value))
        end
        actions.close(prompt_bufnr)  -- Close manually after custom logic
    end
end

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = open_or_switch_to_file,
      },
    },
  },
  extensions = {
    coc = {
        theme = 'ivy',
        prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
    }
  },
})
require('telescope').load_extension('coc')
