# drift.nvim

Let stray thoughts **drift** into a quiet buffer, then slip right back into your code.

A tiny, zen-like mental backlog for Neovim. Quickly jot down what you’re doing, what you’ll do next, or any fleeting idea, without leaving your editor or breaking flow.

---

## Features

- Instant scratch-style backlog buffer for your current session.
- Single command / keymap to open, write, and close.
- Lightweight, no external dependencies.
- Optional persistence between sessions (configurable).
- Simple, text-only interface that plays nice with your colorscheme.

---

## Installation

Use your favorite plugin manager. Examples:

### lazy.nvim

```lua
{
  "yourname/drift.nvim",
  config = function()
    require("drift").setup({
      -- See Configuration section below
    })
  end,
  -- Or
  opts = {
    -- See Configuration section below
  },
}
```

### packer.nvim

```lua
use({
  "yourname/drift.nvim",
  config = function()
    require("drift").setup({
      -- See Configuration section below
    })
  end,
})
```

---

## Configuration

```lua
-- All options are optional!

-- Default setup
require("drift").setup({
	storage = {
		-- Default storage file path: <data_dir>/drift-nvim/drift.txt
		path = vim.fn.stdpath("data") .. "/drift-nvim/",
	},

	win_opts = {
		width = 0.8,
		height = 0.8,
		row = nil,
		col = nil,
		border = nil,
		style = nil,
	},
})
```

---

## Usage

Default commands:

- `:Drift` – Open or toggle the drift buffer. If no buffer exists, it creates one.

You can map these in Lua, for example:

```lua
vim.keymap.set("n", "<leader>od", "<cmd>Drift<CR>", { desc = "Toggle drift backlog" })
```

---

## Roadmap

- [ ] Configurable storage backends (session-only, file, project-local).
- [ ] Simple search or filter for past entries.
- [ ] Optional per-project drift buffers.
- [ ] Better default keymaps and commands.

---

## License

MIT.
