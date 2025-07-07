return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      root = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
      },
    })
  end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "cpp" } },
  },

  {
    "p00f/clangd_extensions.nvim",

    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
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
              "/usr/bin/clangd",
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
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.sorting = opts.sorting or {}
      opts.sorting.comparators = opts.sorting.comparators or {}
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters["cppdbg"] then
        require("dap").adapters["cppdbg"] = {
          id = "cppdbg",
          type = "executable",
          command = "OpenDebugAD7",
          options = {
            detached = false,
          },
        }
      end

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/main", "file")
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = true,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = true,
              },
            },
          },
          {
            name = "Attach to gdbserver :1234",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = "localhost:1234",
            miDebuggerPath = "/usr/bin/gdb",
            cwd = "${workspaceFolder}",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/main", "file")
            end,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = true,
              },
            },
          },
        }
      end
    end,
  },
}
