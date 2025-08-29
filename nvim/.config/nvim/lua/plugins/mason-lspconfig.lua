return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "lua_ls",
      "html",
      "emmet_ls",
      "cssls",
      "tailwindcss",
      "vtsls",
      "astro",
      "marksman",
      "rust_analyzer",
      "bashls",
      "shellcheck",
    },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
