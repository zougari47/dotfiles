-- read :h vim.lsp.config for changing options of lsp servers
require("nvchad.configs.lspconfig").defaults()

local servers = {
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

  html = {},
  emmet_ls = {},
  cssls = {},
  tailwindcss = {},
  ts_ls = {
    init_options = {
      preferences = {
        importModuleSpecifierPreference = "relative",
      },
    },
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git")(fname)
    end,
  },
  astro = {
    init_options = {
      typescript = {
        tsdk = "/home/alpha/.nvm/versions/node/v22.17.1/lib/node_modules/typescript/lib",
      },
    },
  },
  marksman = {},

  rust_analyzer = {},
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end
