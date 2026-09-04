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

return options
