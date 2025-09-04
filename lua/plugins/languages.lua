return {
  -- Rust
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "*",
    lazy = false,
  },

  -- C/C++
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- C/C++ (clangd)
      opts.servers.clangd = {
        mason = false,
        keys = {
          { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        root_dir = function(fname)
          local markers = {
            "pico_sdk_import.cmake",
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja",
            "compile_commands.json",
            "compile_flags.txt",
          }
          local found = vim.fs.find(markers, { path = fname, upward = true })[1]
          return found and vim.fs.dirname(found)
        end,
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = (function()
          local is_cross_compiling = vim.fn.glob("**/pico_sdk_import.cmake") ~= ""
          local base_cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          }
          if is_cross_compiling then
            table.insert(base_cmd, "--query-driver=/usr/bin/arm-none-eabi-*")
          end
          return base_cmd
        end)(),
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }

      -- Python
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

      -- Assembly
      opts.servers.asm_lsp = {
        cmd = { "asm-lsp" },
        filetypes = { "asm", "s", "S" },
      }

      -- Setup functions
      opts.setup = vim.tbl_deep_extend("force", opts.setup or {}, {
        clangd = function(_, server_opts)
          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(
            vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = server_opts })
          )
          return false
        end,
        ruff = function()
          LazyVim.lsp.on_attach(function(client)
            client.server_capabilities.hoverProvider = false
          end, "ruff")
        end,
        hls = function()
          return true
        end,
      })

      -- Disable conflicting servers
      opts.servers.pyright = { enabled = false }
      opts.servers.ruff_lsp = { enabled = false }
    end,
  },

  -- Haskell
  -- {
  --   "mrcjkb/haskell-tools.nvim",
  --   version = "^6",
  --   lazy = false,
  --   init = function()
  --     vim.g.haskell_tools = {
  --       hls = {
  --         default_settings = {
  --           haskell = {
  --             formattingProvider = "ormolu",
  --           },
  --         },
  --       },
  --     }
  --   end,
  -- },

  -- {
  --   "mrcjkb/haskell-snippets.nvim",
  --   dependencies = { "L3MON4D3/LuaSnip" },
  --   ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  --   config = function()
  --     local haskell_snippets = require("haskell-snippets").all
  --     require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
  --   end,
  -- },

  -- CMP enhancements
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      -- C/C++ clangd scores
      opts.sorting = opts.sorting or {}
      opts.sorting.comparators = opts.sorting.comparators or {}
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))

      -- Python auto brackets
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "python")
    end,
  },
}

