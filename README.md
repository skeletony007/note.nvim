### note.nvim

Simple notes manager for Neovim.

### Instalation

Using [lazy.nvim]

```lua
return {
    "skeletony007/note.nvim",

    cmd = { "Note" },

    config = function()
        require("note").setup({ root = "~/notes" })
    end,
}
```

[lazy.nvim]: https://github.com/folke/lazy.nvim

### Telesope Extension

This plugin includes a [telescope.nvim] extension `note` with `find_notes`
picker:

```lua
local telescope = require("telescope")
telescope.load_extension("note")
telescope.extensions.note.find_notes()
```

If you are using lazy.nvim, then you might want to change the Lazy Loading spec
so the extension is loaded before the first `:Note` command.

[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
