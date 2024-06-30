return {

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        asm_lsp = {},
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "asm-lsp",
        "asmfmt",
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
