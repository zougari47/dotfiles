require "nvchad.mappings"

-- Disable mappings
local nomap = vim.keymap.del

nomap("n", "<leader>b")

local map = vim.keymap.set
local tabufline = require "nvchad.tabufline"

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>") -- no desc, ignored

map("n", "<leader>w", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd> q <CR>", { desc = "Quit file" })

map("n", "<leader>o", "o<ESC>", { desc = "Insert new line below" })
map("n", "<leader>O", "O<ESC>", { desc = "Insert new line above" })

map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

map("n", "<leader>bx", function()
  tabufline.closeAllBufs(true)
end, { desc = "Close all buffers including current" })
map("n", "<leader>bX", function()
  tabufline.closeAllBufs(false)
end, { desc = "Close all buffers except current" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

map("n", "<Esc>j", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<Esc>k", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<Esc>j", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<Esc>k", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "<leader>ca", "<cmd> lua vim.lsp.buf.code_action() <CR>", { desc = "LSP code action" })
map(
  "n",
  "<leader>si",
  "<cmd>lua vim.lsp.buf.execute_command({ command = '_typescript.organizeImports', arguments = { vim.api.nvim_buf_get_name(0) } })<cr>",
  { desc = "LSP Sort TypeScript imports" }
)

map(
  "n",
  "<leader>zc",
  "<cmd>lua require('nvim-tree.api').node.collapse()<CR>",
  { desc = "Collapse current folder in NvimTree" }
)
map(
  "n",
  "<leader>ec",
  "<cmd>lua require('nvim-tree.api').tree.collapse_all()<CR>",
  { desc = "Collapse all folders in NvimTree" }
)

map("n", "gl", function()
  vim.diagnostic.open_float { border = "rounded", focusable = true }
end, { desc = "LSP Show floating diagnostic" })

map("n", "gl", vim.diagnostic.open_float, { desc = "Floating diagnostic" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
