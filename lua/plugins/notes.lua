return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~/misc/notes") .. "/**.md",
    "BufNewFile " .. vim.fn.expand("~/misc/notes") .. "/**.md",
  },
  ft = "markdown",
  opts = {
    workspaces = {
      { name = "notes", path = "~/misc/notes" },
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

    disable_frontmatter = true,

    preferred_link_style = "wiki",
    note_id_func = function(title)
      local suffix = title and title:gsub("%s+", "-"):gsub("[^%w%-]", ""):lower() or ""
      return os.date("%Y%m%d%H%M%S") .. (suffix ~= "" and "-" .. suffix or "")
    end,
  },
  keys = function(_, keys)
    vim.keymap.set("n", "<leader>nn", "<cmd>ObsidianNew<CR>", { desc = "New note" })
    vim.keymap.set("n", "<leader>nt", "<cmd>ObsidianToday<CR>", { desc = "Today’s note" })
    vim.keymap.set("n", "<leader>ny", "<cmd>ObsidianYesterday<CR>", { desc = "Yesterday’s note" })
    vim.keymap.set("n", "<leader>ns", "<cmd>ObsidianSearch<CR>", { desc = "Search notes" })
    vim.keymap.set("n", "<leader>nq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch note" })
    vim.keymap.set("n", "<leader>nl", "<cmd>ObsidianLinks<CR>", { desc = "List links in note" })
    vim.keymap.set("n", "<leader>np", "<cmd>ObsidianPasteImg<CR>", { desc = "Paste image" })
    return keys
  end,
}
