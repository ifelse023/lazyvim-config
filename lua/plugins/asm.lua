return {

  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       asm_lsp = {},
  --     },
  --   },
  -- },

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
