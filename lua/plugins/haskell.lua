return {

  {
    "mrcjkb/haskell-tools.nvim",
    version = "^6",
    lazy = false,
    init = function()
      vim.g.haskell_tools = {
        hls = {
          default_settings = {
            haskell = {
              formattingProvider = "ormolu",
            },
          },
        },
      }
    end,
  },

  {
    "mrcjkb/haskell-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip" },
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function()
      local haskell_snippets = require("haskell-snippets").all
      require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
    end,
  },

  -- {
  --   "monkoose/fzf-hoogle.vim",
  --   ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  -- },
  -- Make sure lspconfig doesn't start hls,
  -- as it conflicts with haskell-tools
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        hls = function()
          return true
        end,
      },
    },
  },
}
