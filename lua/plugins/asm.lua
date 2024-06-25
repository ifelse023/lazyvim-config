return {

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        asm_lsp = {
          cmd = { "/home/wasd/.cargo/bin/asm-lsp" }, -- Specify the path to the language server executable
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["asm"] = { "asmfmt" },
      },
    },
  },
}
