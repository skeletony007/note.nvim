local util = require("note.util")

local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local telescope_find_notes = function()
    return pickers
        .new({}, {
            prompt_title = "Find Notes",
            finder = finders.new_table({
                results = util.find_notes(),
            }),
            sorter = conf.generic_sorter(),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    local entries = picker:get_multi_selection()

                    if vim.tbl_isempty(entries) then
                        table.insert(entries, action_state.get_selected_entry())
                    end

                    actions.close(prompt_bufnr)

                    util.open_win(vim.tbl_map(function(entry) return entry.value end, entries))
                end)
                return true
            end,
        })
        :find()
end

return telescope.register_extension({
    exports = {
        find_notes = telescope_find_notes,
    },
})
