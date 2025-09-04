---@class lazyvim.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number

local M = {}

---@param command? string
---@param opts? lazyvim.util.pick.Opts
function M.open(command, opts)
  command = command ~= "auto" and command or "files"
  opts = vim.deepcopy(opts or {})

  if not opts.cwd and opts.root ~= false then
    opts.cwd = LazyVim.root({ buf = opts.buf })
  end

  return require("fzf-lua")[command](opts)
end

---@param command? string
---@param opts? lazyvim.util.pick.Opts
function M.wrap(command, opts)
  return function()
    M.open(command, opts)
  end
end

setmetatable(M, {
  __call = function(_, ...)
    return M.wrap(...)
  end,
})

function M.config_files()
  return M.wrap("files", { cwd = vim.fn.stdpath("config") })
end

return M
