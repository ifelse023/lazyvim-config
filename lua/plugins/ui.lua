return {
  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path() },
          },
          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return { fg = Snacks.util.color("Statement") } end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
          },
        },
        extensions = { "lazy", "fzf" },
      }

      -- do not add trouble symbols if aerial is enabled
      -- And allow it to be overriden for some buffer types (see autocmds)
      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end

      return opts
    end,
  },

  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn",  "",                                                                            desc = "+noice" },
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
      { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "snacks.nvim",
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      image = { enabled = false },
      notifier = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      toggle = { map = vim.keymap.set },
      words = { enabled = true },
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>xn",
        function()
          if Snacks.config.picker and Snacks.config.picker.enabled then
            Snacks.picker.notifications()
          else
            Snacks.notifier.show_history()
          end
        end,
        desc = "Notification History"
      },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    },
  },

  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = [[
    ⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣿⣿
    ⣿⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿
    ⣿⣿⣿⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣢⡦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿
    ⣿⣿⡿⠿⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⢐⣴⣾⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒
    ⣿⣥⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⠖⣠⣴⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⣿⣿⣿⣿⣧⣤⣀⠀⠀⠀⠀⠀⠀⣠⡿⢟⣣⣿⣿⣿⣿⣿⡿⠛⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠
    ⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⢀⣠⣴⣾⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⣠⢂⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣶⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠋
    ⣿⣿⣿⣿⣿⣿⣿⡿⢛⣩⣴⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⣴⡏⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀
    ⣿⣿⣿⣿⣿⢟⡡⣸⣿⣿⡛⠿⢿⣿⡿⢋⣅⠀⣀⣀⡀⠀⠀⠸⣿⢸⣿⡇⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⡿⠿⠿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⣿⣿⣿⡿⢡⣎⣼⣿⣿⣿⢿⣿⣶⣦⣬⣛⡱⢿⣿⣿⠃⢧⣰⡀⠈⢿⣿⣇⠀⠀⠀⢀⠤⠞⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠖⠀⠀⠀⠀⠀
    ⣿⣿⡿⣡⣿⣿⢛⣿⣿⣿⣷⣮⣍⡛⠿⣿⣿⣶⡍⣁⢾⠸⣿⣇⠀⢀⣹⣿⡄⠀⢀⣀⢠⣤⣶⣶⠂⠀⠀⢠⣤⡆⠀⠀⢀⠀⠀⠀⠀⠀⠀⢀⣀⣄⡀⠀⣠⣾⠏⠀⠀⠀⠀⠀⠀
    ⣿⢟⣴⣿⣿⣵⣿⣿⣿⣿⣿⣿⣿⣿⣷⣮⡻⣿⢃⣿⠘⠷⠍⣛⢿⣿⣿⣿⣷⣷⣿⣷⢸⣿⣿⣿⣷⣤⣴⣿⣿⣶⣿⣟⣁⣠⣤⠄⠆⣡⣾⠟⠛⠛⠻⣆⠟⠁⠀⠀⠀⠀⠀⠀⠀
    ⣵⣿⣿⣿⣿⣿⣿⣿⣧⣛⠿⠿⣿⠿⠿⣿⠃⠏⣼⣿⠁⣷⣦⣤⣉⠻⢏⣿⣿⣿⠿⠿⠦⠍⠬⠭⠭⠝⠿⠿⣿⣿⣿⣿⣿⣿⣿⣶⣾⠟⠁⠀⢀⣴⣶⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⣿⣿⣿⣿⣿⡿⠛⣛⡛⣫⣾⣄⡲⣾⡿⣁⢈⣾⣿⣿⡆⢻⣿⣿⠟⣣⣾⣿⣿⣿⣾⣿⣶⣶⣶⣶⣴⣦⣤⣤⣬⣽⣿⣿⣿⣿⣿⣿⣿⠄⠀⠐⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⣿⣿⣿⣿⣿⣿⣿⣏⢼⡿⠿⢛⣛⣫⣼⡏⣼⣿⣿⣿⣯⢸⣿⣧⣘⡛⠛⢛⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⢁⣀⢠⣼⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⣿⣿⣿⣿⣿⣿⣿⡟⣠⣶⣿⣿⣿⣿⡟⣰⣿⣿⣿⣿⣿⣆⢻⣿⣿⣿⡟⢿⣿⣿⣿⣿⡿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣥⣶⣶⣶⣿⠿⣋⣥⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⣿⣿⣿⣿⣿⣿⢟⣴⣿⣿⣿⣿⣿⢏⣼⣿⣿⣿⣿⣿⣿⣿⣦⡻⣿⣿⣿⣷⡶⢶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣱⣮⡍⣛⣛⣭⣶⣾⣿⣿⣿⣿⣦⢀⣤⣤⣤⣶⣶⣶⣶
    ⡿⢿⡿⠿⠛⣵⣾⣿⣿⣿⠿⣋⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡙⣿⣿⣿⣷⣤⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢏⣼⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠹⢿⣿⣿⣿⣿⣿
    ⣿⣿⢟⣻⣷⣬⡭⣉⣭⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣌⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢲⣭⣙⠿⣿⣿
    ⣯⣵⣿⠿⠟⢡⣾⠟⠛⠿⠿⠛⢛⢋⣉⣉⣉⣉⣉⠛⡛⠛⠿⢿⡿⠛⣀⠙⢿⣿⣿⣿⣿⠿⠿⠟⠛⠉⢁⣤⣾⣿⣿⣿⡏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣹⣿⣿⣦⣉
    ⠀⠀⠀⠀⠀⣼⠁⠀⠙⢦⡙⣎⡓⣎⠶⣑⢎⠖⣥⠛⡼⢩⠖⢀⢤⠣⠁⢀⡴⠀⠀⢀⡀⠀⠄⢂⣤⣾⣿⣿⣿⣿⣿⣿⢣⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⢹⢰⡍⣶⢩⡞⡌⠉⣶⢹⡌⡅⢢⠋⣦⠁⢠⡎⠀⠀⣴⣿⡇⢲⠘⣿⣿⣿⣿⣿⣿⣿⣿⡏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⠖⣣⠹⣤⢋⠔⢠⡹⢤⢣⡝⡸⢀⠏⠄⣀⡒⠀⠠⣶⡜⢿⣿⢸⠳⢹⣿⣿⣿⣿⣿⣿⣿⢃⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟
    ⣠⣦⠀⠀⠀⠀⠀⠀⠀⠀⡹⣐⠯⣐⠂⡐⢦⢓⡣⢇⡎⢁⡜⠊⡰⠂⠀⢠⣷⣶⣭⣘⡻⣾⣇⢻⣿⣿⣿⣿⣿⣿⡏⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⣟⣿⣿⡿⢋⡕⣚
    ⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠰⡑⢎⠀⡠⡜⣣⢍⡞⣡⠊⡔⠌⡰⠁⠀⠀⢸⣿⣿⣿⣿⣿⣦⡙⠘⣿⣿⣿⣿⣿⡟⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣋⣵⣶⣿⣿⣿⠟⡡⢲⡍⡞⢥
    ⣷⣮⣅⠀⠀⠀⠀⠀⠀⠀⠐⡹⠀⢠⢣⡕⣣⠞⣰⠃⢰⠸⡑⠂⠀⠀⠀⠀⠛⢿⣿⣿⣿⣿⣿⣦⣻⣿⣿⡿⢟⣘⣩⣭⣭⣭⣥⣭⣭⣭⣭⣥⣬⣭⣝⣛⠟⠋⣡⢎⡵⢣⢞⡸⠁
    ⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠁⢀⡳⣊⠶⣑⢮⡑⠀⣇⠳⠈⠀⠀⠀⠀⠀⠀⠀⠙⠻⢿⣿⣿⣿⣿⣿⣵⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⢠⡚⣥⢚⣌⠳⡊⠀⠔
    ⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⣎⡱⢎⡵⢩⢦⠁⢸⠰⡉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠉⠁⠀⠀⢠⣘⢣⡕⢎⡵⢊⠁⡄⢁⡎
    ⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⡜⣰⠣⣍⠶⣩⠆⠀⣣⢓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⢀⡰⢃⢮⡱⢎⠳⠌⣀⠃⢤⠳⣘
    ⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⢄⡳⣡⢛⡴⡹⠄⠠⠐⣥⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢆⡳⣍⠶⣑⠋⢀⡒⢀⡜⣎⠵⣩
]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
}
