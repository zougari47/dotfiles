require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>w", "<cmd> w <CR>")
map("n", "<leader>q", "<cmd> q <CR>")

map("n", "<leader>o", "o<ESC>")
map("n", "<leader>O", "O<ESC>")

map("n", "<leader>nh", "<cmd>nohlsearch<CR>")

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
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
