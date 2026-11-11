-- snacks.nvim: one plugin covering picker, explorer, dashboard,
-- buffer delete, indent guides and the floating input box.
--
-- revert: each feature below lists the plugin it replaced. To go back, add that
-- plugin in its own file and point the keymaps in init.lua back at it.

vim.pack.add { "https://github.com/folke/snacks.nvim" }

require("snacks").setup {
  -- was: Telescope (NvChad) | now: Snacks picker
  -- revert: add telescope.nvim and point the <leader>f* keys back to `:Telescope ...`
  picker = {
    enabled = true,
    -- Snacks' <Tab> marks the item and <CR> then opens the marked ones; Telescope's <CR>
    -- ignored the marks, so <Tab> felt like "move down". Make it just move, like before.
    win = {
      input = {
        keys = {
          ["<Tab>"] = { "list_down", mode = { "i", "n" } },
          ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
        },
      },
    },
    sources = {
      -- was: nvim-tree (side = "right", adaptive_size, dotfiles shown, quit_on_open)
      -- now: Snacks explorer, fixed width (no adaptive size)
      -- revert: we might go back to nvim-tree if the explorer doesn't feel right;
      --         add nvim-tree.lua with the old opts and point <C-n>, <leader>e, <leader>zc, <leader>ec back to it
      explorer = {
        hidden = true,
        jump = { close = true },
        layout = { layout = { position = "right" } },
        -- inside the explorer <C-n> is "next item" by default, which hid the global <C-n> toggle
        win = {
          list = { keys = { ["<C-n>"] = "close" } },
          input = { keys = { ["<C-n>"] = { "close", mode = { "n", "i" } } } },
        },
      },
    },
  },
  explorer = { enabled = true },

  -- was: Nvdash (load_on_startup) | now: Snacks dashboard
  -- The default "startup" section reads lazy.nvim's stats, so it's left out (we use vim.pack)
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },

  -- was: indent-blankline.nvim | now: Snacks indent
  indent = { enabled = true },

  -- was: Snacks input (already used for the rename popup) | now: same
  input = { enabled = true },
}
