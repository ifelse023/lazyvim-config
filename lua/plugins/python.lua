return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.basedpyright = {
        enabled = true,
        cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "recommended",
              diagnosticMode = "workspace",
              autoImportCompletions = true,
              autoSearchPaths = true,
            },
          },
        },
      }

      opts.servers.ruff = {
        enabled = true,
        cmd = { "uv", "run", "ruff", "server" },
        init_options = { settings = { logLevel = "error" } },
        keys = {
          { "<leader>co", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" },
        },
      }

      opts.setup = vim.tbl_deep_extend("force", opts.setup or {}, {
        ruff = function()
          LazyVim.lsp.on_attach(function(client)
            client.server_capabilities.hoverProvider = false
          end, "ruff")
        end,
      })

      opts.servers.pyright = { enabled = false }
      opts.servers.ruff_lsp = { enabled = false }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "python")
    end,
  },
}
