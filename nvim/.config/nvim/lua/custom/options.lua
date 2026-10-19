-- Settings (loaded before plugins)

-- ===== [mine] =====
-- was: nvchad.options + options.lua | now: the same values, set here
local o = vim.o

o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

vim.opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true -- keep absolute number on current line
o.relativenumber = true
o.numberwidth = 2
o.ruler = false
o.wrap = false

-- disable nvim intro
vim.opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append "<>[]hl"

-- disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- was: lazy.nvim performance.rtp.disabled_plugins (also disabled ftplugin and syntax)
-- now: nothing disabled
-- ===== end [mine] =====

-- ===== [kickstart] extra options (delete this block to get plain NvChad behaviour) =====
o.breakindent = true

-- Show tabs, trailing spaces and non-breaking spaces
o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
o.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
o.scrolloff = 10

-- Ask to save instead of failing when quitting with unsaved changes
o.confirm = true

-- was: NvChad diagnostic config | now: kickstart's
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      }
    end,
  },
}
-- ===== end [kickstart] =====
