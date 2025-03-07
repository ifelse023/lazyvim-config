return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local lspconfig = require("lspconfig")
    lspconfig.asm_lsp.setup({
      cmd = { "/home/wasd/.cargo/bin/asm-lsp" },
      filetypes = { "asm", "s", "S" },
      root_dir = lspconfig.util.root_pattern(".git", "Makefile", "justfile", "."),
      settings = {
        asm_lsp = {
          -- You can enable debugging or other options here
        },
      },
    })
  end,
}
