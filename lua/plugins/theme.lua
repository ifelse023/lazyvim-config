return {
  -- catppuccin support
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      highlight_overrides = {
        mocha = function(cp)
          return {
            YankyYanked = {
              bg = cp.peach,
              fg = cp.mantle,
              bold = true,
            },
            YankyPut = {
              bg = cp.lavender,
              fg = cp.mantle,
            },
          }
        end,
      },
      integrations = {
        blink_cmp = true,
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        notifier = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotree = false,
        noice = true,
        semantic_tokens = true,
        snacks = {
          enabled = true,
          indent_scope_color = "lavender",
        },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
          end
        end,
      },
    },
  },
}
