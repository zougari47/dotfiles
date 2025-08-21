require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>") -- no desc, ignored

map("n", "<leader>w", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd> q <CR>", { desc = "Quit file" })

map("n", "<leader>o", "o<ESC>", { desc = "Insert new line below" })
map("n", "<leader>O", "O<ESC>", { desc = "Insert new line above" })

map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

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
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
