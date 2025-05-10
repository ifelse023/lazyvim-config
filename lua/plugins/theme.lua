return {

  -- {
  --
  --   "scottmckendry/cyberdream.nvim",
  --
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     variant = "dark",
  --     overrides = function(colors)
  --       return {
  --         FlashBackdrop = { fg = colors.bg_highlight },
  --         FlashLabel = { fg = colors.blue, bg = colors.bg, bold = true },
  --         FlashMatch = { fg = colors.magenta, bg = colors.bg },
  --         FlashCurrent = { fg = colors.green, bg = colors.bg },
  --         FlashPrompt = { link = "NormalFloat" },
  --         ["@keyword.return"] = { fg = "#5ef1ff", bold = true },
  --         ["@character.printf"] = { fg = "#2ac3de" },
  --       }
  --     end,
  --   },
  -- },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
