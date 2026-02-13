return {
  "danymat/neogen",
  version = "*",
  config = function()
    local neogen = require("neogen")

    require('neogen').setup({
    enabled = true,
    languages = {
        cpp = {
            template = {
                annotation_convention = "doxygen"
            }
        },
      }
    })

    -- Generate annotation
    vim.keymap.set("n", "<leader>dd", function()
      neogen.generate()
    end, { desc = "Generate annotation" })

    -- Your manual docblock insert
    vim.keymap.set("n", "<leader>ds", "O/**<space><space>*/<Esc>F<space>i", {
      desc = "Insert docblock skeleton",
    })
  end,
}
