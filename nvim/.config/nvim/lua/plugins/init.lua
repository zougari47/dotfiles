return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap["<Tab>"] = { "accept", "fallback" }
      opts.keymap["<CR>"] = { "fallback" }
      return opts
    end,
  },

  {
    "abecodes/tabout.nvim",
    lazy = false,
    config = function()
      require("tabout").setup {} -- Inherit all defaults
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Required
    event = "InsertCharPre",
    priority = 1000,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertCharPre",
    opts = {},
  },
}
