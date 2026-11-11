-- Editing helpers. Loaded after treesitter.lua (tabout, autotag and render-markdown use it).

vim.pack.add {
  "https://github.com/abecodes/tabout.nvim",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
}

require("tabout").setup {}

require("nvim-ts-autotag").setup {}

-- was: ft = { "markdown", "Avante" } | now: markdown only (avante isn't installed). Toggle with <leader>rm
require("render-markdown").setup {
  enabled = false,
}
