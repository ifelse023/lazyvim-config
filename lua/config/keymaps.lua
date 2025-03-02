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
-- Ctrl-Tab to jump to previous window
vim.keymap.set("n", "<C-Tab>", "<cmd>wincmd W<cr>", { desc = "Switch to previous window" })
-- Split window vertically (to the right)
vim.keymap.set("n", "<A-s>", "<cmd>vsplit<CR>", { desc = "Split window vertically" })

-- Center the cursor in the window
vim.keymap.set("n", "zz", "zz", { desc = "Recenter screen" })

-- Using Alt+w for next window (works in terminal mode too)
vim.keymap.set({ "n", "t" }, "<A-w>", function()
  if vim.fn.mode() == "t" then
    -- If in terminal mode, first switch to normal mode in the terminal
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), "n", false)
    -- Then switch window
    vim.cmd("wincmd w")
  else
    -- If already in normal mode, just switch window
    vim.cmd("wincmd w")
  end
end, { desc = "Switch to next window (terminal-aware)" })
----------------------------------------------
-- Buffer Navigation
----------------------------------------------
-- Go to the next buffer
vim.keymap.set("n", "<A-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Create a new tab
vim.keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "New tab" })

vim.keymap.set("n", "<A-q>", "<cmd>bd<CR>", { desc = "Delete buffer" })

----------------------------------------------
-- Line Navigation
----------------------------------------------
-- Jump down 10 lines and center cursor
vim.keymap.set("n", "<leader>j", "10jzz", { desc = "Jump down 10 lines and center" })
-- Jump up 10 lines and center cursor
vim.keymap.set("n", "<leader>k", "10kzz", { desc = "Jump up 10 lines and center" })

-- Alternative mappings using Alt key
vim.keymap.set("n", "<C-j>", "10jzz", { desc = "Jump down 10 lines and center" })
vim.keymap.set("n", "<C-k>", "10kzz", { desc = "Jump up 10 lines and center" })
----------------------------------------------
-- Neovide Specific Settings
----------------------------------------------
if vim.g.neovide then
  vim.keymap.set("n", "<C-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<C-c>", '"+y') -- Copy
  vim.keymap.set("n", "<C-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<C-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<C-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<C-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-v>", "<C-R>+", { noremap = true, silent = true })
-- Zoom in and out with Ctrl+= and Ctrl+-

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.25)
end)

vim.keymap.set("n", "<C-0>", function()
  vim.g.neovide_scale_factor = 1.0
end, { desc = "Reset font size" })
