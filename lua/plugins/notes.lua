return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("obsidian").setup {
      workspaces = {
        {
          name = "notes",
          path = "~/misc/notes",
        },
      },
      note_id_func = function(title)
        local prefix = tostring(os.date("%Y-%m-%d", os.time()))
        if title ~= nil then
          title =
              title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          title = os.time()
        end
        return prefix .. "-" .. title
      end,
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        default_tags = { "daily-notes" },
        workdays_only = false,
      },

      ui = {
        enable = false,
      },

      picker = {
        name = "fzf-lua",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },
      sort_by = "modified",
    }

    vim.keymap.set("n", "<leader>nn", "<cmd>ObsidianFollowLink<cr>")
    vim.keymap.set("n", "<leader>nN", "<cmd>ObsidianNew<cr>")
    vim.keymap.set("n", "<leader>no", "<cmd>ObsidianOpen<cr>")
    vim.keymap.set("n", "<leader>nd", "<cmd>ObsidianDailies<cr>")
    vim.keymap.set("n", "<leader>nrn", "<cmd>ObsidianRename<cr>")
    vim.keymap.set("n", "<leader>nT", "<cmd>ObsidianTemplate<cr>")
    vim.keymap.set("n", "<leader>nb", "<cmd>ObsidianBacklinks<cr>")
    vim.keymap.set("n", "<leader>nfg", "<cmd>ObsidianSearch<cr>")
  end,
}
