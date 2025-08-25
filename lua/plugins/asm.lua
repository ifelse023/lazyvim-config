return {
  "neovim/nvim-lspconfig",
  opts = function(_)
    local lspconfig = require("lspconfig")
    lspconfig.asm_lsp.setup({
      cmd = { "asm-lsp" },
      filetypes = { "asm", "S", "s" },
      root_dir = lspconfig.util.root_pattern(".git", "justfile"),
      settings = {
        asm_lsp = {},
      },
    })
  end,
}
