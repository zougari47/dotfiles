-- LSP: mason installs servers/tools, vim.lsp.config configures them.
-- LSP keymaps live in init.lua.

vim.pack.add {
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
}

-- ===== [kickstart] =====
-- Useful status updates for LSP.
require("fidget").setup {}

-- Highlight references of the word under the cursor when it rests there
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight", event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
        end,
      })
    end
  end,
})
-- ===== end [kickstart] =====

-- ===== [mine] =====
-- was: NvChad on_init disabled semanticTokens for every server (colours come from treesitter only)
-- now: same. To turn semantic highlighting back on, delete this autocmd.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("mine-no-semantic-tokens", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

-- was: lspconfig[name].setup(opts) (deprecated) | now: vim.lsp.config(name, opts) + vim.lsp.enable(name)
---@type table<string, vim.lsp.Config>
local servers = {
  -- Web / Frontend
  astro = {
    -- was: init_options.typescript.tsdk hard-coded to ~/.nvm/versions/node/v22.17.1/...
    -- now: the project's own typescript, else the copy bundled with mason's astro-language-server
    --      (no global typescript needed, works whatever node version nvm has active)
    before_init = function(params, config)
      local function usable(lib)
        return lib and vim.uv.fs_stat(lib .. "/tsserverlibrary.js") ~= nil -- TS 7 dropped this file
      end

      local project_ts = vim.fs.find("node_modules/typescript/lib", {
        path = config.root_dir,
        upward = true,
        type = "directory",
      })[1]
      local bundled_ts = vim.fn.stdpath "data"
        .. "/mason/packages/astro-language-server/node_modules/typescript/lib"

      -- edit in place: the initialize request was already built from config.init_options
      config.init_options = config.init_options or {}
      config.init_options.typescript = config.init_options.typescript or {}
      config.init_options.typescript.tsdk = usable(project_ts) and project_ts or bundled_ts
      params.initializationOptions = config.init_options
    end,
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
  -- was: globals = { "vim" } + workspace.library = runtime files
  -- now: kickstart's lua_ls setup, which covers both and leaves formatting to stylua
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath "config"
          and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          version = "LuaJIT",
          path = { "lua/?.lua", "lua/?/init.lua" },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
      })
    end,
    settings = {
      Lua = {
        format = { enable = false },
      },
    },
  },

  -- TypeScript / JavaScript
  vtsls = {},

  -- Systems / Other
  rust_analyzer = {},
}

require("mason").setup {}

require("mason-lspconfig").setup {
  automatic_enable = false,
}

-- was: mason-lspconfig ensure_installed (with shellcheck wrongly listed as a server) + chadrc mason.pkgs { "oxfmt" }
-- now: one list for servers and tools
local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, {
  "oxfmt",
  "stylua",
  "shfmt",
  "shellcheck",
  "tree-sitter-cli", -- needed by nvim-treesitter (main branch) to build parsers
})
require("mason-tool-installer").setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
-- ===== end [mine] =====
