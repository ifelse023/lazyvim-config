return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    dap.configurations.c = {
      {
        name = "Launch My C Program",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
      },
    }
  end,
}
