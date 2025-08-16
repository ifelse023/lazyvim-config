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
}
-- {
--   "catppuccin/nvim",
--   lazy = true,
--   name = "catppuccin",
--   opts = {
--     flavour = "mocha",
--     color_overrides = {
--       mocha = {
--         base = "#11111b", -- darker background
--         mantle = "#101018",
--         crust = "#000000",
--         surface0 = "#1e1e2e",
--         text = "#d7dff9",
--         overlay1 = "#8a8fad",
--         overlay0 = "#7a7f96",
--       },
--     },
--     highlight_overrides = {
--       mocha = function(c)
--         return {
--           FlashLabel = { bg = "#16181a", fg = "#5eff6c", bold = true },
--           FlashMatch = { fg = c.fg_dark },
--           FlashCurrent = { bg = "#16181a", fg = c.orange, bold = true },
--
--           YankyPut = { bg = "#1b2b1b", fg = "#9ef79e", bold = true },
--           YankyYanked = { bg = "#2b1b2b", fg = "#f79ef7", bold = true },
--         }
--       end,
--       integrations = {
--         aerial = true,
--         cmp = true,
--         flash = true,
--         fzf = true,
--         headlines = true,
--         indent_blankline = { enabled = true },
--         lsp_trouble = true,
--         markdown = true,
--         markview = true,
--         mini = true,
--         native_lsp = {
--           enabled = true,
--           underlines = {
--             errors = { "undercurl" },
--             hints = { "undercurl" },
--             warnings = { "undercurl" },
--             information = { "undercurl" },
--           },
--         },
--         navic = { enabled = true, custom_bg = "lualine" },
--         noice = true,
--         notify = true,
--         semantic_tokens = true,
--         snacks = true,
--         treesitter = true,
--         treesitter_context = true,
--         which_key = true,
--       },
--     },
--     specs = {
--       {
--         "akinsho/bufferline.nvim",
--         optional = true,
--         opts = function(_, opts)
--           if (vim.g.colors_name or ""):find("catppuccin") then
--             opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
--           end
--         end,
--       },
--     },
--   },
-- },
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

--
