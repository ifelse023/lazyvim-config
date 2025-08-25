return {
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
    -- disable_frontmatter = true,
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
}
