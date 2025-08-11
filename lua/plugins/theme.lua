return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "dark",
      italic_comments = true,
      overrides = function(hl)
        return {
          flashbackdrop = { fg = hl.bg_highlight },
          flashlabel = { fg = hl.green, bold = true },
          flashmatch = { fg = hl.fg },
          flashcurrent = { fg = hl.magenta, bold = true },
          ["@boolean.c"] = { fg = hl.orange },
          ["@character.printf"] = { fg = "#2ac3de" },
          ["@lsp.typemod.function.defaultlibrary"] = { fg = "#2bbac5" },
          ["@keyword.directive.c"] = { fg = "#f5c2e7" },
          ["cprecondit"] = { fg = "#f5c2e7" },
          ["cdefine"] = { fg = "#f5c2e7" },
          ["cinclude"] = { fg = "#f5c2e7" },
          ["@keyword.directive.define.c"] = { fg = "#f5c2e7" },
          ["@keyword.import.c"] = { fg = "#f5c2e7" },
          ["@lsp.type.parameter.c"] = { fg = hl.red },
          ["@keyword.modifier.c"] = { fg = "#ff9e64" },
        }
      end,
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      require("cyberdream").load()
    end,
  },

  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("tokyonight").setup({
  --       on_highlights = function(hl, c)
  --         hl.FlashLabel = { bg = "#16181a", fg = "#5eff6c", bold = true }
  --         hl.FlashMatch = { fg = c.fg_dark }
  --         hl.FlashCurrent = { bg = "#16181a", fg = c.orange, bold = true }
  --       end,
  --     })
  --   end,
  -- },
}
