# drift.nvim

Let stray thoughts **drift** into a quiet buffer, then slip right back into your code.

A tiny, zen-like mental backlog for Neovim. Quickly jot down what you’re doing, what you’ll do next, or any fleeting idea, without leaving your editor or breaking flow.

---

## Features

- Instant scratch-style backlog buffer for your current session
- Single command / keymap to open, write, and close
- Lightweight, no external dependencies
- Simple, text-only interface that plays nice with your color scheme

[Screencast from 2026-02-03 13-14-16.webm](https://github.com/user-attachments/assets/4eaeae32-bf7f-4418-8d66-56c5a6583f7b)

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
-- Everything is optional!

-- Default setup
require("drift-nvim").setup({
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

-- Example with all options
require("drift-nvim").setup({
  keymaps = {
    ['<leader>od'] = { -- Toggle drift buffer
      action = 'toggle',
      desc = 'Toggle Drift backlog',
    }
  }

  notify = true, -- Enable notifications when auto-saving

  storage = {
    path = "~/Documents/drift/", -- Custom storage path
  },

  win_opts = {
    width = 0.6,
    height = 0.6,
    row = nil,
    col = nil,
    border = nil,
    style = nil,
    on_open = function()
      vim.notify("Drift buffer opened!")
    end,
    on_close = function()
      vim.notify("Drift buffer closed!")
    end,
  },
})
```

---

## Usage

Default commands:

- `:Drift` – Open or toggle the drift buffer.

You can map these in Lua yourself, for example:

```lua
vim.keymap.set("n", "<leader>od", "<cmd>Drift<CR>", { desc = "Toggle drift backlog" })
```

---

## Roadmap

- [ ] Support for multiple drift buffers/entries.
- [ ] Simple search or filter for past entries.
- [ ] Optional per-project drift buffers.

---

## License

[MIT](./LICENSE.md) © 2026 Leonardo A. Alvarenga
