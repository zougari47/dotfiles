-- Treesitter: highlighting, indentation
-- was: nvim-treesitter master branch (frozen) with ensure_installed
-- now: main branch; parsers are built with tree-sitter-cli (installed by mason, see lsp.lua)

vim.pack.add { { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } }

-- was: same list under ensure_installed
local parsers = {
  -- Neovim essentials
  "vim",
  "lua",
  "vimdoc",

  -- Web stack
  "html",
  "css",
  "javascript",
  "typescript",
  "tsx",
  "astro",

  -- Rust
  "rust",
  "toml",

  -- Config / data formats
  -- was: "json", "jsonc" | now: "json" only (main branch has no jsonc parser; json handles .jsonc)
  "json",
  "yaml",

  -- Docs
  "markdown",
  "markdown_inline",

  -- Shell
  "bash",

  -- Database
  "sql",
}
require("nvim-treesitter").install(parsers)

-- ===== [kickstart] =====
---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if not vim.treesitter.language.add(language) then
    return
  end

  vim.treesitter.start(buf, language)

  local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil
  if has_indent_query then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

-- Start treesitter on every filetype; install a missing parser on first use
local available_parsers = require("nvim-treesitter").get_available()
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    local installed_parsers = require("nvim-treesitter").get_installed "parsers"

    if vim.tbl_contains(installed_parsers, language) then
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      require("nvim-treesitter").install(language):await(function()
        treesitter_try_attach(buf, language)
      end)
    else
      treesitter_try_attach(buf, language)
    end
  end,
})
-- ===== end [kickstart] =====
