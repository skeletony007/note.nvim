local transliterations = require("note.transliterations")

local M = {}

--- Turn a string into kebab case
---@param s string
---@return string kebab_string kebab-case string
M.to_kebab = function(s)
    s = table.concat(vim.split(s:lower(), "%s+", { trimempty = true }), "-")
    return s
end

--- Check if a string is valid as a note name
---@param s string
---@return boolean
M.is_valid_name = function(s) return not s:find("[^a-z0-9%-/]") end

--- Converts a string into an acceptable format for use in notes names
---@param s string
---@return string name valid name
M.conv = function(s)
    local prefix_padding = s:match("^(%s*)") or ""
    local postfix_padding = s:match("(%s*)$") or ""
    for _, item in ipairs(transliterations) do
        local pattern, replacement = item[1], item[2]
        s = s:gsub("(%s*)" .. pattern .. "(%s*)", function(left, right)
            if left ~= "" or right ~= "" then
                if right == "" then
                    return left .. replacement .. " "
                elseif left == "" then
                    return " " .. replacement .. right
                else
                    return left .. replacement .. right
                end
            else
                return " " .. replacement .. " "
            end
        end)
    end
    local name = M.to_kebab(prefix_padding .. vim.trim(s) .. postfix_padding)
    if not M.is_valid_name(name) then
        error(string.format("invalid name: %s", name))
    end
    return name
end

return M
