return {
  "Aejkatappaja/sora",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require("sora").setup(opts)
    vim.cmd("colorscheme sora")
  end,
}
