local util = require("note.util")

require("note.user_commands")

M = {}

M.setup = function(opts)
    opts = opts or { root = "~/notes" }
    util.set_root(opts.root)
end

return M
