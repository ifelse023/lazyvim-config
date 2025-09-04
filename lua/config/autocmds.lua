local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  command = "norm zz",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "asm", "nasm", "gas" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- Helix-like directory picker behavior for Neovim + fzf-lua (Neovim ≥ 0.10)
local grp = vim.api.nvim_create_augroup("DirPicker", { clear = true })

local function realdir(p)
  return vim.uv.fs_realpath(p) or p
end

local function open_picker_for_dir(dir, start_buf)
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return
  end
  local actions = require("fzf-lua.actions")
  fzf.files({
    cwd = dir,
    actions = {
      ["default"] = function(sel, opts)
        actions.file_edit(sel, opts)
        if start_buf then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(start_buf) then
              pcall(vim.api.nvim_buf_delete, start_buf, { force = true })
            end
          end)
        end
      end,
    },
  })
end

-- On startup: open picker if started with a single directory arg, or with no args (CWD).
vim.api.nvim_create_autocmd("VimEnter", {
  group = grp,
  desc = "Open picker on startup for dir arg or CWD",
  callback = function()
    if #vim.api.nvim_list_uis() == 0 then
      return
    end
    local argc = vim.fn.argc()
    local start_buf = vim.api.nvim_get_current_buf()

    if argc == 1 then
      local arg = vim.fn.argv(0) --[[@as string]]
      if vim.fn.isdirectory(arg) == 1 then
        vim.b[start_buf].dirpicker_done = true
        open_picker_for_dir(realdir(arg), start_buf)
      end
      return
    end

    if argc == 0 then
      vim.b[start_buf].dirpicker_done = true
      open_picker_for_dir(realdir(vim.uv.cwd()), start_buf)
    end
  end,
})

-- When entering a directory buffer later, open the picker for that directory once.
vim.api.nvim_create_autocmd("BufEnter", {
  group = grp,
  desc = "Open picker when entering a directory buffer",
  callback = function(args)
    if vim.b[args.buf].dirpicker_done then
      return
    end
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name == "" or vim.fn.isdirectory(name) ~= 1 then
      return
    end
    vim.b[args.buf].dirpicker_done = true
    open_picker_for_dir(realdir(name), args.buf)
  end,
})
