return {
  "terror/just-lsp",        -- 1️⃣ GitHub repo for just-lsp
  ft = { "just" },          -- 2️⃣ Trigger on *.just files
  config = function()
    local lspconfig = require("lspconfig")
    local util      = require("lspconfig.util")
    lspconfig.just.setup({
      cmd      = { "just-lsp" },
      filetypes = { "just" },
      root_dir = util.root_pattern(".git"),
    })
  end,
}
