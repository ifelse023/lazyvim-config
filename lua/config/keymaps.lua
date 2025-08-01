-- ───────────────────────────────────────
-- Helpers
-- ───────────────────────────────────────
local function map(mode, lhs, rhs, desc, extra_opts)
  local opts = vim.tbl_extend("force", { noremap = true, silent = true, desc = desc }, extra_opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

local nmap = function(lhs, rhs, desc, opts)
  map("n", lhs, rhs, desc, opts)
end

-- ───────────────────────────────────────
-- Window navigation / management
-- ───────────────────────────────────────
nmap("<A-h>", "<C-w>h", "Move to left window")
nmap("<A-j>", "<C-w>j", "Move to below window")
nmap("<A-k>", "<C-w>k", "Move to above window")
nmap("<A-l>", "<C-w>l", "Move to right window")

nmap("<A-s>", ":vsplit<CR>", "Split window vertically")
nmap("<A-v>", ":split<CR>", "Split window horizontally")
nmap("<A-q>", ":close<CR>", "Close current window")
nmap("<Tab>", "<C-w>w", "Next window")

-- ───────────────────────────────────────
-- Buffers / tabs
-- ───────────────────────────────────────
nmap("<C-]>", ":bnext<CR>", "Next buffer")
nmap("<A-[>", ":bprev<CR>", "Previous buffer")
nmap("<A-t>", ":tabnew<CR>", "New tab")
nmap("<C-q>", function()
  Snacks.bufdelete()
end, "Delete buffer")

-- ───────────────────────────────────────
-- Cursor movement + recenter helpers
-- ───────────────────────────────────────
nmap("<C-d>", "<C-d>zz", "Half-page down + center")
nmap("<C-u>", "<C-u>zz", "Half-page up + center")
nmap("<C-j>", "10jzz", "Jump ↓ 10 + center")
nmap("<C-k>", "10kzz", "Jump ↑ 10 + center")
nmap("zz", "zz", "Recenter screen")

-- ───────────────────────────────────────
-- Editing miscellany
-- ───────────────────────────────────────
nmap("<leader>v", "viw", "Select inner word")
nmap("<F2>", vim.lsp.buf.rename, "Rename symbol")

-- ───────────────────────────────────────
-- chezmoi one-shot helper
-- ───────────────────────────────────────
nmap("<leader>sz", function()
  vim.fn.jobstart({ "chezmoi", "apply", "--force" }, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      local level = code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
      vim.notify("chezmoi apply exited with code " .. code, level)
    end,
  })
end, "chezmoi apply")

nmap("<leader>on", ":edit ~/misc/notes/random.md<CR>", "Open quick-notes")

-- ───────────────────────────────────────
-- GUI / Neovide-specific tweaks
-- ───────────────────────────────────────
if vim.g.neovide then
  nmap("<S-s>", ":w<CR>", "Save file")

  map({ "n", "v" }, "<C-S-v>", '"+P', "Paste from clipboard")
  map("v", "<C-S-c>", '"+y', "Copy to clipboard")
  map("c", "<C-S-v>", "<C-R>+", "Paste (cmd-line)")
  map("i", "<C-S-v>", '<Esc>"+Pli', "Paste (insert)")

  nmap("<A-CR>", ":vsplit<CR>", "Split window vertically")
  nmap("<A-Tab>", ":bnext<CR>", "Next buffer")

  -- Neovide zoom
  local function scale(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  nmap("<C-=>", function()
    scale(1.25)
  end, "Zoom in")
  nmap("<C-->", function()
    scale(1 / 1.25)
  end, "Zoom out")
  nmap("<C-0>", function()
    vim.g.neovide_scale_factor = 1
  end, "Zoom reset")
end

-- ───────────────────────────────────────
-- macOS clipboard (⌘V)
-- ───────────────────────────────────────
for _, mode in ipairs({ "", "v", "t" }) do
  map(mode, "<D-v>", '"+p', "Paste from system clipboard")
end
map("!", "<D-v>", "<C-R>+", "Paste (insert-cmd)")
map("c", "<D-v>", "<C-R>+", "Paste (cmd-line)")
