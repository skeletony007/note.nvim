local case = require("note.case")

local M = {}

-- note_root is initialized in setup
local root = ""

M.set_root = function(r) root = vim.fs.normalize(r) end

M.get_root = function()
    if root == "" then
        error("root not set. Did you call setup()?")
    end
    return root
end

M.find_notes = function()
    local some_invalid
    local notes = vim.tbl_map(
        function(item) return item:sub(#root + 2, -4) end,
        vim.fs.find(function(item)
            if not item:match("%.md$") then
                return false
            end
            if not case.is_valid_name(item:sub(#root + 2, -4)) then
                some_invalid = true
                return false
            end
            return true
        end, {
            limit = math.huge,
            type = "file",
            path = M.get_root(),
        })
    )
    vim.notify("[note.nvim] not using some notes with invalid names", vim.log.levels.WARN, { title = "note.nvim" })
    return notes
end

M.find_invalid_notes = function()
    return vim.tbl_map(
        function(item) return item:sub(#root + 2, -4) end,
        vim.fs.find(function(item)
            if not (item:match("%.md$") and not case.is_valid_name(item:sub(#root + 2, -4))) then
                return false
            end
            return true
        end, {
            limit = math.huge,
            type = "file",
            path = M.get_root(),
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
        if not case.is_valid_name(fname) then
            vim.notify(string.format("[note.nvim] invalid name: %s", fname), vim.log.levels.WARN, { title = "note.nvim" })
        end
        local buf = vim.fn.bufadd(string.format("%s/%s.md", M.get_root(), fname))
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
