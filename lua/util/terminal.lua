---@class lazyvim.util.terminal
local M = {}

---@param shell? string
function M.setup(shell)
  vim.o.shell = shell or vim.o.shell
end

return M
