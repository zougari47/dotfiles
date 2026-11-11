-- Completion + snippets (blink.cmp reads the friendly-snippets collection by itself)

vim.pack.add {
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.*" },
}

-- was: nvim-cmp (NvChad). Your blink.cmp spec never loaded, so these are the keys you actually used.
-- now: blink.cmp with the same keys
--
-- The blink keys you had written but never ran:
--   ["<Tab>"] = { "accept", "fallback" },
--   ["<CR>"] = { "fallback" },
require("blink.cmp").setup {
  keymap = {
    preset = "none",
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-d>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
  },

  -- ===== [kickstart] =====
  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  fuzzy = { implementation = "lua" },

  signature = { enabled = true },
  -- ===== end [kickstart] =====

  -- was: nvim-cmp sources nvim_lsp, luasnip, buffer, nvim_lua, async_path
  -- now: kickstart's lsp, path, snippets + buffer
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
}
