local util = require("note.util")

local notes_command = function(opts) util.open_win(opts.fargs) end

local notes_complete = function(_, line)
    local l = vim.split(line, "%s+")
    return vim.tbl_filter(function(val) return vim.startswith(val, l[#l]) end, util.find_notes())
end

vim.api.nvim_create_user_command("Note", notes_command, {
    nargs = "*",
    complete = notes_complete,
})
