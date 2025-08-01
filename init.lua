local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  spec = {
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        delay = 30,
        preset = "helix",
        defaults = {},
        spec = {
          {
            mode = { "n", "v" },
            { "<leader><tab>", group = "tabs" },
            { "<leader>c", group = "code" },
            { "<leader>d", group = "debug" },
            { "<leader>dp", group = "profiler" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>gh", group = "hunks" },
            { "<leader>q", group = "quit/session" },
            { "<leader>s", group = "search" },
            { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
            { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
            { "gs", group = "surround" },
            { "z", group = "fold" },
            {
              "<leader>b",
              group = "buffer",
              expand = function()
                return require("which-key.extras").expand.buf()
              end,
            },
            {
              "<leader>w",
              group = "windows",
              proxy = "<c-w>",
              expand = function()
                return require("which-key.extras").expand.win()
              end,
            },
            -- better descriptions
            { "gx", desc = "Open with system app" },
          },
        },
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Keymaps (which-key)",
        },
        {
          "<c-w><space>",
          function()
            require("which-key").show({ keys = "<c-w>", loop = true })
          end,
          desc = "Window Hydra Mode (which-key)",
        },
      },
      config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        if not vim.tbl_isempty(opts.spec) then
          wk.add(opts.spec)
        end
      end,
    },

    { "nvim-lua/plenary.nvim", lazy = true },
    { dir = "/home/wasd/misc/LazyVim", import = "lazyvim.plugins" },

    { import = "plugins.lsp.lsp" },
    { import = "plugins" },

    {
      "nvim-neo-tree/neo-tree.nvim",
      enabled = false,
    },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "2html_plugin",
      },
    },
  },
})

vim.cmd.colorscheme("catppuccin")
