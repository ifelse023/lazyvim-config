return {

  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
    lazy = true,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "just",
      },
    },
  },
}
