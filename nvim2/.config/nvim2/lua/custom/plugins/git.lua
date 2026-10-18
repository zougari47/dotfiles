-- Git: signs in the gutter + diff view (keymaps in init.lua; lazygit lives in snacks.lua)

vim.pack.add {
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/sindrets/diffview.nvim",
}

-- was: NvChad gitsigns config | now: same signs, no keymaps (NvChad had none either)
require("gitsigns").setup {
  signs = {
    delete = { text = "󰍵" },
    changedelete = { text = "󱕖" },
  },

  -- ===== [kickstart] gitsigns keymaps (disabled) =====
  -- <leader>h* would clash with my <leader>h (new horizontal terminal)
  --
  -- on_attach = function(bufnr)
  --   local gitsigns = require 'gitsigns'
  --   vim.keymap.set('n', ']c', function()
  --     if vim.wo.diff then
  --       vim.cmd.normal { ']c', bang = true }
  --     else
  --       gitsigns.nav_hunk 'next'
  --     end
  --   end, { desc = 'Jump to next git [c]hange', buf = bufnr })
  --   vim.keymap.set('n', '[c', function()
  --     if vim.wo.diff then
  --       vim.cmd.normal { '[c', bang = true }
  --     else
  --       gitsigns.nav_hunk 'prev'
  --     end
  --   end, { desc = 'Jump to previous git [c]hange', buf = bufnr })
  --   vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk', buf = bufnr })
  --   vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = 'git [D]iff against last commit', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk [Q]uickfix list (all files in repo)', buf = bufnr })
  --   vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)', buf = bufnr })
  --   vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line', buf = bufnr })
  --   vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr })
  --   vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'text object [i]nside [h]unk', buf = bufnr })
  -- end,
  -- ===== end [kickstart] =====
}

require("diffview").setup {
  enhanced_diff_hl = true,
  use_icons = true,
}
