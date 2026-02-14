return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        cc = { "clang_format" },
        h = { "clang_format" },
        hpp = { "clang_format" },

        python = { "ruff_format" },
        json = { "prettier" },
        xml = { "prettier" },
        cmake = { "cmake_format" },
      },

      formatters = {
        clang_format = {
          prepend_args = function()
            local home = vim.fn.expand("~")
            return { "--style=file:" .. home .. "/.clang-format" }
          end,
        },
      },
    })

    local function format_current_line()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
      conform.format({
        async = false,
        lsp_fallback = false,
        range = {
          start = { row, 0 },
          ["end"] = { row, #line },
        },
      })
    end

    -- Visual mode → format selection (full lines)
    vim.keymap.set("v", "<leader>c", function()
      conform.format({ async = false, lsp_fallback = false })
    end, { desc = "Format selection" })

    -- Normal mode → format current line only
    vim.keymap.set("n", "<leader>c", format_current_line, { desc = "Format current line" })
  end,
}
