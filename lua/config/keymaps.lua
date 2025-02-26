-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>wn", ':vsplit | lua Snacks.dashboard.pick("files")<CR>', {
  noremap = true,
  silent = true,
  desc = "Split window and open file picker",
})
----------------------------------------------
-- Window and Tab Navigation
----------------------------------------------
-- Switch to the next window
vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<cr>", { desc = "Switch to next window" }) -- Duplicated mapping

-- Split window vertically (to the right)
vim.keymap.set("n", "<A-s>", "<cmd>vsplit<CR>", { desc = "Split window vertically" })

-- Center the cursor in the window
vim.keymap.set("n", "zz", "zz", { desc = "Recenter screen" })

----------------------------------------------
-- Buffer Navigation
----------------------------------------------
-- Go to the next buffer
vim.keymap.set("n", "<A-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Create a new tab
vim.keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "New tab" })

vim.keymap.set("n", "<A-q>", "<cmd>bd<CR>", { desc = "Delete buffer" })

----------------------------------------------
-- Neovide Specific Settings
----------------------------------------------
-- Font scaling for Neovide
vim.g.neovide_scale_factor = 1.0

local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

-- Zoom in and out with Ctrl+= and Ctrl+-
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end, { desc = "Increase font size" })

vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.25)
end, { desc = "Decrease font size" })

-- Neovide specific key mappings (for macOS)
if vim.g.neovide then
  -- macOS standard shortcuts
  vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file" }) -- Save
  vim.keymap.set("v", "<D-c>", '"+y', { desc = "Copy to clipboard" }) -- Copy
  vim.keymap.set("n", "<D-v>", '"+P', { desc = "Paste from clipboard" }) -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P', { desc = "Paste from clipboard" }) -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+", { desc = "Paste from clipboard" }) -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli', { desc = "Paste from clipboard" }) -- Paste insert mode
end

----------------------------------------------
-- Universal Clipboard Support
----------------------------------------------
-- Allow clipboard copy paste in all Neovim modes
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "Paste from clipboard" })
