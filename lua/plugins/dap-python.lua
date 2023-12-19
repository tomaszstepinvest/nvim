return {
  {
    "mfussenegger/nvim-dap-python",
  -- stylua: ignore
  keys = {
    { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
    { "<leader>dpr", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
    { "<leader>dpa", function() require('neotest').run.run({strategy = 'dap'}) end, desc = "Debug Method", ft = "python" },
    { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  },
    config = function()
      local function prune_nil(items)
        return vim.tbl_filter(function(x)
          return x
        end, items)
      end

      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
      require("dap.ext.vscode").load_launchjs()

      local test_runners = require("dap-python").test_runners
      test_runners.pytest = function(classname, methodname, opts)
        local path = vim.fn.expand("%:p")
        local test_path = table.concat(prune_nil({ path, classname, methodname }), "::")
        -- -s "allow output to stdout of test"
        local args = { "-s", "--reuse-db", test_path }
        return "pytest", args
      end
    end,
  },
}
