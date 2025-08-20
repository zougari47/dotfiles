return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      -- Neovim essentials
      "vim", "lua", "vimdoc",

      -- Web stack
      "html", "css",
      "javascript", "typescript", "tsx",
      "astro",

      -- Rust
      "rust", "toml",

      -- Config / data formats
      "json", "jsonc",
      "yaml",

      -- Docs
      "markdown", "markdown_inline",

      -- Shell
      "bash",
    },
  },
}
