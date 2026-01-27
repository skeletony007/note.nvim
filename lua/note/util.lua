M = {}

-- note_root is initialized in setup
local root = ""

M.set_root = function(r)
    root = vim.fs.normalize(r)
end

M.get_root = function()
    return root
end

M.find_notes = function()
    return vim.tbl_map(
        function(item) return item:sub(#root + 2, -4) end,
        vim.fs.find(function(name) return name:match(".*%.md$") end, {
            limit = math.huge,
            type = "file",
            path = root,
        })
    )
end

--- Open note buffers in windows. Firstly in the current window, then new splits
--- (in a nested spiral pattern of repeating "left", "above", "right", and "below")
---@param notes string[] array of window names
---@return integer[]|nil wins array of each new window ID, or nil on error
M.open_win = function(notes)
    local wins = {}
    local split_direction = { "below", "left", "above", "right" }
    for i, fname in ipairs(notes) do
        local buf = vim.fn.bufadd(string.format("%s/%s.md", root, fname))
        table.insert(wins, i, buf)
        if i == 1 then
            vim.api.nvim_win_set_buf(0, buf)
        else
            vim.api.nvim_open_win(buf, true, { split = split_direction[i % 4] })
        end
    end
    return wins
end

return M
