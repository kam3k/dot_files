return {
  "slugbyte/lackluster.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local lackluster = require("lackluster")
    local color = lackluster.color
    lackluster.setup({
      color_overrides = {
        red = "#8B3E2F",
        red_dim = "#A0522D",
      },
      tweak_syntax = {
        comment = color.gray5
      },
      tweak_background = {
        normal = 'none',
      },
    })
    vim.cmd.colorscheme("lackluster-hack")
  end,
}
