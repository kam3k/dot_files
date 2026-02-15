return {
  "stevearc/overseer.nvim",

  keys = {
    -- Run build
    { "<leader>b", "<cmd>OverseerRun cpp-build<cr>", desc = "Build project" },

    -- Cancel running build
    {
      "<leader>n",
      function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ status = "RUNNING" })
        for _, task in ipairs(tasks) do
          task:stop()
        end
      end,
      desc = "Cancel build",
    },

    -- Toggle quickfix window
    {
      "<leader><leader>",
      function()
        if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
          vim.cmd("cclose")
        else
          vim.cmd("copen")
        end
      end,
      desc = "Toggle quickfix",
    },
  },

  opts = {
    task_list = {
      direction = "bottom",
      min_height = 15,
      max_height = 15,
      default_detail = 1,
    },
  },

  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    overseer.register_template({
      name = "cpp-build",

      builder = function()
        return {
          name = "C++ Build",
          cmd = { "cmake", "--build", "build" },
          cwd = vim.fn.getcwd(),

          components = {
            "default",
            "on_output_quickfix",
          },

          -- 🔴 Open quickfix + jump to first error on failure
          on_exit = function(_, code)
            if code ~= 0 then
              local qf = vim.fn.getqflist({ size = 0 })
              if qf.size > 0 then
                vim.schedule(function()
                  vim.cmd("copen")
                  vim.cmd("cfirst")
                end)
              end
            end
          end,
        }
      end,
    })
  end,
}
