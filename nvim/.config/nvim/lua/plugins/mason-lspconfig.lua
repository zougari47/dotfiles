return
{
    "mason-org/mason-lspconfig.nvim",
    opts = {
ensure_installed = {
        "lua_ls",
        "html",
        "emmet_ls",
        "cssls",
        "tailwindcss",
        "ts_ls",
        "astro",
        "marksman",
        "rust_analyzer",
        "bashls",
      },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
} 
