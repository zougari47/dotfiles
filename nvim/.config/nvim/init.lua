-- nvim: built from kickstart.nvim (https://github.com/nvim-lua/kickstart.nvim, commit 8e35dbe)
--
-- Markers used throughout this config:
--   [kickstart]  code kept from kickstart
--   [mine]       my own settings and keymaps (these win over kickstart)
--   was: ... | now: ...   what this replaced from the old NvChad config (dotfiles/archive/nvim)
--
-- Plugins are managed by the built-in vim.pack:
--   :lua vim.pack.update()   update plugins
--   lock file: nvim-pack-lock.json

-- ===== [kickstart] =====
vim.loader.enable()

-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true -- Hack Nerd Font is installed
-- ===== end [kickstart] =====

-- ===== [mine] =====
require "custom.options"
require "custom.pack"

-- Plugins, loaded in this order on purpose:
--   lsp before format/treesitter (mason puts tools on PATH),
--   editing after treesitter (tabout, autotag, render-markdown use it)
-- was: NvChad base46 palenight, then palenightfall.nvim
-- now: built-in colorschemes; the last one you pick is remembered
require "custom.theme"
require "custom.plugins.ui"
require "custom.plugins.snacks"
require "custom.plugins.lsp"
require "custom.plugins.completion"
require "custom.plugins.format"
require "custom.plugins.treesitter"
require "custom.plugins.git"
require "custom.plugins.editing"

require "custom.keymaps"
require "custom.autocmds"
-- ===== end [mine] =====

-- vim: ts=2 sts=2 sw=2 et
