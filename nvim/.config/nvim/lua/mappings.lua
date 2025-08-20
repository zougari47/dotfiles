require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>o", "o<ESC>")
map("n", "<leader>O", "O<ESC>")
map("n", "<Esc>j", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<Esc>k", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<Esc>j", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<Esc>k", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
