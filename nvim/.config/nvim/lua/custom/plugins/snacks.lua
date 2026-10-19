-- snacks.nvim: one plugin covering picker, explorer, dashboard, terminal,
-- lazygit, buffer delete, indent guides and the floating input box.
--
-- revert: each feature below lists the plugin it replaced. To go back, add that
-- plugin in its own file and point the keymaps in init.lua back at it.

vim.pack.add { "https://github.com/folke/snacks.nvim" }

-- was: lazygit.nvim layered lazygit.yml (Neovim-only layout tweaks) on top of your lazygit config
-- now: same layering through LG_CONFIG_FILE; Snacks appends its theme file after these
local lazygit_files = {
  vim.fn.expand "~/.config/lazygit/config.yml",
  vim.fn.stdpath "config" .. "/lazygit.yml",
}
vim.env.LG_CONFIG_FILE = table.concat(
  vim.tbl_filter(function(f)
    return vim.uv.fs_stat(f) ~= nil
  end, lazygit_files),
  ","
)

require("snacks").setup {
  -- was: Telescope (NvChad) | now: Snacks picker
  -- revert: add telescope.nvim and point the <leader>f* keys back to `:Telescope ...`
  picker = {
    enabled = true,
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

  -- was: nvchad.term | now: Snacks terminal (keys in init.lua)
  terminal = { enabled = true },

  -- was: lazygit.nvim (vim.g.lazygit_floating_window_scaling_factor = 1)
  -- now: Snacks lazygit, full size, coloured to match the theme, `e` edits in this nvim
  lazygit = {
    enabled = true,
    win = { width = 0, height = 0 },
  },
}
