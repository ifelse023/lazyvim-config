local M = {}

M.moved = {
  lsp = {
    rename_file = { "Snacks.rename.rename_file" },
    on_rename = { "Snacks.rename.on_rename_file" },
    words = { "Snacks.words" },
  },

  ui = {
    statuscolumn = { "Snacks.statuscolumn" },
    bufremove = { "Snacks.bufdelete" },
    fg = {
      "{ fg = Snacks.util.color(...) }",
      fn = function(...)
        return { fg = Snacks.util.color(...) }
      end,
    },
  },
}

function M.toggle()
  return {
    map = function() end,
    wrap = function()
      return {}
    end,
  }
end

return M
