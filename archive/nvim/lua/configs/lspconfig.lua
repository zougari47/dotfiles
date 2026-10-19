-- read :h vim.lsp.config for changing options of lsp servers
require("nvchad.configs.lspconfig").defaults()

local servers = {
  -- Web / Frontend
  astro = {
    init_options = {
      typescript = {
        tsdk = "/home/alpha/.nvm/versions/node/v22.17.1/lib/node_modules/typescript/lib",
      },
    },
  },
  cssls = {
    settings = {
      css = {
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  },
  emmet_ls = {
    filetypes = { "html", "javascriptreact", "typescriptreact", "astro" },
    init_options = {
      html = {
        options = {
          ["bem.enabled"] = true,
          ["self_closing_style"] = "xhtml",
          ["showSuggestionsAsSnippets"] = false, -- Prevents snippets for non-tag words
          ["showAbbreviationSuggestions"] = false, -- Disables suggestions for arbitrary words
        },
      },
    },
  },
  html = {},
  tailwindcss = {
    settings = {
      tailwindCSS = {
        classFunctions = { "cva", "cn" },
      },
    },
  },

  -- Markup / Docs
  marksman = {},

  -- Scripting / Languages
  bashls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  },

  -- TypeScript / JavaScript
  vtsls = {},

  -- Systems / Other
  rust_analyzer = {},
}

local lspconfig = require "lspconfig"
for name, opts in pairs(servers) do
  -- vim.lsp.enable(name)
  -- vim.lsp.config(name, opts)
  opts = opts or {}
  lspconfig[name].setup(opts)
end

require("lspconfig").vtsls.setup {}
