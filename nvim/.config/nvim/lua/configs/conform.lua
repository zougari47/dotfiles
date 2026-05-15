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

local prettierOnlyFts = {
  "astro",
  "xml",
}

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

for _, ft in ipairs(oxfmtFts) do
  options.formatters_by_ft[ft] = { "oxfmt" }
end

for _, ft in ipairs(prettierOnlyFts) do
  options.formatters_by_ft[ft] = { "prettierd", "prettier" }
end

return options
