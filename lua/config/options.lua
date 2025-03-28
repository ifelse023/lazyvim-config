-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

vim.cmd([[
    let g:loaded_ruby_provider = 0
    let g:loaded_perl_provider = 0
]])
vim.opt.timeoutlen = 200 --
vim.g.snacks_animate = false

-- Neovide
vim.g.neovide_refresh_rate = 60
vim.g.neovide_remember_window_size = true
vim.g.neovide_floating_corner_radius = 0.33
vim.g.experimental_layer_grouping = true
