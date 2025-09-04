---@class lazyvim.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

local M = {}

---@param command? string
---@param opts? lazyvim.util.pick.Opts
function M.open(command, opts)
  command = command ~= "auto" and command or "files"
  opts = opts or {}
  opts = vim.deepcopy(opts)

  if type(opts.cwd) == "boolean" then
    LazyVim.warn("LazyVim.pick: opts.cwd should be a string or nil")
    opts.cwd = nil
  end

  if not opts.cwd and opts.root ~= false then
    opts.cwd = LazyVim.root({ buf = opts.buf })
  end

  if opts.cmd == nil and command == "git_files" and opts.show_untracked then
    opts.cmd = "git ls-files --exclude-standard --cached --others"
  end

  return require("fzf-lua")[command](opts)
end

---@param command? string
---@param opts? lazyvim.util.pick.Opts
function M.wrap(command, opts)
  opts = opts or {}
  return function()
    M.open(command, vim.deepcopy(opts))
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
