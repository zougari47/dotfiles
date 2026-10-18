-- Editing helpers. Loaded after treesitter.lua (tabout, autotag and render-markdown use it).

vim.pack.add {
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/abecodes/tabout.nvim",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
}

-- was: NvChad autopairs opts (+ nvim-cmp confirm hook) | now: same opts; blink adds brackets on accept by itself
require("nvim-autopairs").setup {
  fast_wrap = {},
  disable_filetype = { "vim" },
}

require("tabout").setup {}

require("nvim-ts-autotag").setup {}

require("todo-comments").setup {}

-- was: ft = { "markdown", "Avante" } | now: markdown only (avante isn't installed). Toggle with <leader>rm
require("render-markdown").setup {
  enabled = false,
}
