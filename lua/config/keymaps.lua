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
vim.keymap.set("n", "<A-k>", "<cmd>close<CR>", { desc = "Close current window" })
vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<cr>", { desc = "Switch to next window" })
vim.keymap.set("n", "<C-Tab>", "<cmd>wincmd W<cr>", { desc = "Switch to previous window" })
vim.keymap.set("n", "<leader>v", "viw", { desc = "Select inner word" })
vim.keymap.set("n", "<leader>fm", function()
  require("oil").open(vim.loop.cwd())
end, { desc = "Open Oil file explorer" })

vim.keymap.set("n", "q", "<nop>", { noremap = true })
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
vim.keymap.set("n", "<C-q>", "<cmd>bd<CR>", { desc = "Delete buffer" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
vim.keymap.set("n", "<C-j>", "10jzz", { desc = "Jump down 10 lines and center" })
vim.keymap.set("n", "<C-k>", "10kzz", { desc = "Jump up 10 lines and center" })

vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })


vim.keymap.set("n", "<leader>sz", function()
  vim.fn.jobstart({ "chezmoi", "apply", "--force" }, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,

    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,

    on_exit = function(_, code)
      if code == 0 then
        vim.notify("chezmoi apply finished successfully", vim.log.levels.INFO)
      else
        vim.notify("chezmoi apply failed (exit code " .. code .. ")", vim.log.levels.ERROR)
      end
    end,
  })
end, { noremap = true, silent = true })


vim.keymap.set('n', '<leader>on', '<cmd>edit ~/misc/notes/random.md<CR>', { desc = 'Open quicknotes file' })

if vim.g.neovide then
  vim.keymap.set('n', '<S-s>', ':w<CR>')        -- Save
  vim.keymap.set('v', '<C-S-c>', '"+y')         -- Copy
  vim.keymap.set('n', '<C-S-v>', '"+P')         -- Paste normal mode
  vim.keymap.set('v', '<C-S-v>', '"+P')         -- Paste visual mode
  vim.keymap.set('c', '<C-S-v>', '<C-R>+')      -- Paste command mode
  vim.keymap.set('i', '<C-S-v>', '<ESC>l"+Pli') -- Paste insert mode


  vim.keymap.set("n", "<A-CR>", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })


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
