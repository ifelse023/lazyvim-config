return {
  -- Just (build tool)
  {
    "terror/just-lsp",
    ft = { "just" },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      lspconfig.just.setup({
        cmd = { "just-lsp" },
        filetypes = { "just" },
        root_dir = util.root_pattern(".git"),
      })
    end,
  },

  -- JSON + Schema support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        marksman = {}, -- Markdown LSP
      },
    },
  },

  -- Markdown
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  -- Markdown Rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      require("snacks")
        .toggle({
          name = "Render Markdown",
          get = function()
            return require("render-markdown.state").enabled
          end,
          set = function(enabled)
            local m = require("render-markdown")
            if enabled then
              m.enable()
            else
              m.disable()
            end
          end,
        })
        :map("<leader>um")
    end,
  },

  -- Notes (Obsidian)
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand("~/notes") .. "/**.md",
      "BufNewFile " .. vim.fn.expand("~/notes") .. "/**.md",
    },
    ft = "markdown",
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "notes", path = "~/notes" },
      },
      picker = { name = "fzf-lua" },
      completion = { blink = true, nvim_cmp = false, min_chars = 2, create_new = true },
      notes_subdir = "notes",
      new_notes_location = "notes_subdir",
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%Y-%m-%d",
        template = "daily.md",
        workdays_only = false,
      },
      attachments = {
        img_folder = "assets/img",
        confirm_img_paste = true,
      },
      preferred_link_style = "wiki",
    },
    keys = function(_, keys)
      vim.keymap.set("n", "<leader>nn", "<cmd>Obsidian new<CR>", { desc = "New note" })
      vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<CR>", { desc = "Today's note" })
      vim.keymap.set("n", "<leader>ny", "<cmd>Obsidian yesterday<CR>", { desc = "Yesterday's note" })
      vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<CR>", { desc = "Search notes" })
      vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<CR>", { desc = "Quick switch note" })
      vim.keymap.set("n", "<leader>nl", "<cmd>Obsidian links<CR>", { desc = "List links in note" })
      vim.keymap.set("n", "<leader>ni", "<cmd>Obsidian paste_img<CR>", { desc = "Paste image" })
      return keys
    end,
  },
}

