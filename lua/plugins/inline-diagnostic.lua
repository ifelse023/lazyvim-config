return {

  "rachartier/tiny-inline-diagnostic.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({})
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      jump = {
        on_jump = vim.diagnostic.open_float,
      },
    })
  end,
}
