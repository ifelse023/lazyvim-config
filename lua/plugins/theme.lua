return {

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "dark",
      overrides = function(colors)
        return {
          FlashBackdrop = { fg = colors.bg_highlight },
          FlashLabel = { fg = colors.blue, bg = colors.bg, bold = true },
          FlashMatch = { fg = colors.magenta, bg = colors.bg },
          FlashCurrent = { fg = colors.green, bg = colors.bg },
          FlashPrompt = { link = "NormalFloat" },
          ["@keyword.return"] = { fg = "#5ef1ff" },
          ["@boolean.c"] = { fg = colors.orange },
          ["@character.printf"] = { fg = "#2ac3de" },
          ["@lsp.typemod.function.defaultLibrary"] = { fg = "#2bbac5" },
          ["@keyword.directive.c"] = { fg = "#f5c2e7" },
          ["cPreCondit"] = { fg = "#f5c2e7" },
          ["cDefine"] = { fg = "#f5c2e7" },
          ["cInclude"] = { fg = "#f5c2e7" },
          ["@keyword.directive.define.c"] = { fg = "#f5c2e7" },
          ["@keyword.import.c"] = { fg = "#f5c2e7" },
          ["@lsp.type.parameter.c"] = { fg = colors.red },
          ["@lsp.type.parameter.cpp"] = { fg = "#ff7eb6" },
          ["@keyword.modifier.c"] = { fg = "#ff9e64" },
        }
      end,
    },
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
  },
  -- Using Lazy
  {
    "navarasu/onedark.nvim",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
