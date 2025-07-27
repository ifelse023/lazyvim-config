return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      fish_lsp = {
        cmd = { "fish-lsp" }, -- full path if not in PATH
        filetypes = { "fish" },
        root_dir = require("lspconfig.util").root_pattern(".git", "*.fish"),
      },
    },
  },
}
