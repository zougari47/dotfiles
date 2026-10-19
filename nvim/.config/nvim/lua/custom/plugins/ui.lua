-- Statusline, buffer tabs, icons, text objects, keymap hints

vim.pack.add {
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/folke/which-key.nvim",
}

-- ===== [kickstart] mini.nvim =====
-- was: nvim-web-devicons | now: mini.icons, pretending to be devicons for plugins that ask for it
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Better Around/Inside textobjects
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require("mini.ai").setup {
  -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
  mappings = {
    around_next = "aa",
    inside_next = "ii",
  },
  n_lines = 500,
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--  - sd'   - [S]urround [D]elete [']quotes
--  - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

-- was: NvChad statusline | now: mini.statusline
local statusline = require "mini.statusline"
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end
-- ===== end [kickstart] =====

-- ===== [mine] =====
-- was: NvChad tabufline (buffers scoped per tab page) | now: mini.tabline (all listed buffers)
require("mini.tabline").setup()

-- was: NvChad which-key defaults (delay ~timeoutlen) | now: same plugin, kickstart's group labels replaced by mine
require("which-key").setup {
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { "<leader>b", group = "Buffers" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>W", group = "Workspace / WhichKey" },
    { "gr", group = "LSP Actions" },
  },
}
-- ===== end [mine] =====

-- ===== [kickstart] which-key settings (disabled) =====
-- require('which-key').setup {
--   delay = 0,
--   spec = {
--     { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
--     { '<leader>t', group = '[T]oggle' },
--     { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
--   },
-- }
-- ===== end [kickstart] =====
