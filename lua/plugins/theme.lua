return {
  {
    "miikanissi/modus-themes.nvim",
    opts = {
      style = "auto",
      variant = "default",
      on_highlights = function(hl, c)
        hl["@character.printf"] = { fg = c.cyan_warmer }
        hl["@lsp.typemod.function.defaultlibrary"] = { fg = c.indigo }
        hl["@lsp.type.parameter.c"] = { fg = c.fg_alt }
        hl["@keyword.directive.c"] = { fg = "#ffbd5e" }
        hl["@keyword.directive.define.c"] = { fg = "#ffbd5e" }
        hl["@keyword.import.c"] = { fg = "#ffbd5e" }
      end,
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "dark",
      italic_comments = true,
      colors = {
        bg = "#000000",
        -- bg_alt = "#0f0f0f",
        -- bg_highlight = "#1e1e1e",
        fg = "#ffffff",
      },
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
}
