-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>")

vim.keymap.set("n", "<leader>cx", function()
  require("cmp").setup.buffer({ enabled = false })
end, { desc = "Disable buffer completion" })

vim.keymap.set("n", "<leader>cz", function()
  require("cmp").setup.buffer({ enabled = true })
end, { desc = "Disable buffer completion" })
