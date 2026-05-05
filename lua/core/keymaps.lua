local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<A-k>", "<cmd>resize +2<CR>", { desc = "Resize taller" })
map("n", "<A-j>", "<cmd>resize -2<CR>", { desc = "Resize shorter" })
map("n", "<A-h>", "<cmd>vertical resize -2<CR>", { desc = "Resize narrower" })
map("n", "<A-l>", "<cmd>vertical resize +2<CR>", { desc = "Resize wider" })

map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "n", "nzzzv", { desc = "Next match, centre" })
map("n", "N", "Nzzzv", { desc = "Prev match, centre" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centre" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centre" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" })

map("n", "<leader>vv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>hh", "<cmd>split<CR>", { desc = "Split horizontally" })

map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "H", "<cmd>bprevious<CR>", { desc = "Prev buffer" })

map("n", "ge", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

map("n", "x", '"_x', { desc = "Delete char without yanking" })
map("v", "p", '"_dP', { desc = "Paste without yanking selection" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal: leave insert" })
