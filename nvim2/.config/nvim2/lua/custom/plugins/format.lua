-- Formatting (keymap <leader>fm in init.lua)

vim.pack.add { "https://github.com/stevearc/conform.nvim" }

local oxfmtFts = {
  "html", "css", "scss", "less",
  "javascript", "javascriptreact",
  "typescript", "typescriptreact",
  "json", "jsonc",
  "yaml", "toml",
  "graphql",
  "markdown", "mdx",
  "vue",
}

local formatters_by_ft = {
  lua = { "stylua" },
  sh = { "shfmt" },
  bash = { "shfmt" },
}

for _, ft in ipairs(oxfmtFts) do
  formatters_by_ft[ft] = { "oxfmt" }
end

require("conform").setup {
  formatters_by_ft = formatters_by_ft,

  -- was: format_on_save = { timeout_ms = 2000, lsp_fallback = true } | now: same, lsp_fallback renamed to lsp_format
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },

  -- ===== [kickstart] =====
  notify_on_error = false,
  -- ===== end [kickstart] =====
}
