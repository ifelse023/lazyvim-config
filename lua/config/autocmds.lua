-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  command = "norm zz",
})


vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = os.getenv("HOME") .. "/.local/share/chezmoi/*",
  callback = function()
    vim.fn.jobstart({ "chezmoi", "apply" }, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_exit = function(_, code)
        if code == 0 then
          vim.schedule(function()
            vim.notify("chezmoi apply succeeded", vim.log.levels.INFO)
          end)
        else
          vim.schedule(function()
            vim.notify("chezmoi apply failed", vim.log.levels.ERROR)
          end)
        end
      end,
    })
  end,
})

if vim.g.neovide then
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      os.execute("hyprctl dispatch focusworkspaceoncurrentmonitor 2")
    end
  })
end
