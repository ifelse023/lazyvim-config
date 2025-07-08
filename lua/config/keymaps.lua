vim.keymap.set("n", "<leader>wn", ':vsplit | lua Snacks.dashboard.pick("files")<CR>', {
  noremap = true,
  silent = true,
  desc = "Split window and open file picker",
})

vim.keymap.set("n", "<A-h>", "<cmd>wincmd h<cr>", { desc = "Move to left window" })
vim.keymap.set("n", "<A-j>", "<cmd>wincmd j<cr>", { desc = "Move to below window" })
vim.keymap.set("n", "<A-k>", "<cmd>wincmd k<cr>", { desc = "Move to above window" })
vim.keymap.set("n", "<A-l>", "<cmd>wincmd l<cr>", { desc = "Move to right window" })
vim.keymap.set("n", "<A-s>", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<A-v>", "<cmd>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<A-q>", "<cmd>close<CR>", { desc = "Close current window" })
vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<cr>", { desc = "Switch to next window" })
vim.keymap.set("n", "<C-Tab>", "<cmd>wincmd W<cr>", { desc = "Switch to previous window" })

vim.keymap.set("n", "<leader>fm", function()
  require("oil").open(vim.loop.cwd())
end, { desc = "Open Oil file explorer" })

-- Center the cursor in the window
vim.keymap.set("n", "zz", "zz", { desc = "Recenter screen" })

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

vim.keymap.set("n", "<A-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<A-d>", "<cmd>bd<CR>", { desc = "Delete buffer" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
vim.keymap.set("n", "<C-j>", "10jzz", { desc = "Jump down 10 lines and center" })
vim.keymap.set("n", "<C-k>", "10kzz", { desc = "Jump up 10 lines and center" })

vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })

local dap = require("dap")

vim.keymap.set("n", "<F10>", function()
  dap.step_over()
end, { desc = "Debug: Step Over" })

vim.keymap.set("n", "<F11>", function()
  dap.step_into()
end, { desc = "Debug: Step Into" })

vim.keymap.set("n", "<F12>", function()
  dap.step_out()
end, { desc = "Debug: Step Out" })

vim.keymap.set("n", "<F9>", function()
  dap.toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })

vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-v>", '"+P')
vim.keymap.set("v", "<C-v>", '"+P')
vim.keymap.set("c", "<C-v>", "<C-R>+")
vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli')

-- Terminal, command-line and general paste mappings
vim.api.nvim_set_keymap("", "<C-v>", '"+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<C-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-v>", "<C-R>+", { noremap = true, silent = true })
