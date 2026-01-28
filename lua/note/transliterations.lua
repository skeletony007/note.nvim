local printable_ascii = require("note.transliterations.printable-ascii")
local extended_ascii = require("note.transliterations.extended-ascii")

return vim.list_extend(printable_ascii, extended_ascii)
