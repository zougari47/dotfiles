local prettierFts = {
  "html",
  "css",
  "scss",
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "jsx",
  "tsx",
  "json",
  "jsonc",
  "yaml",
  "graphql",
  "markdown",
  "mdx",
  "astro",
  "toml",
  "xml",
  "gitignore",
  "prettierignore",
  "prettierrc",
}

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },

  -- Optional: Enable format on save
  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

-- Add prettierd to all prettier-supported file types
for _, ft in pairs(prettierFts) do
  options.formatters_by_ft[ft] = { "prettierd", "prettier" }
end

return options
