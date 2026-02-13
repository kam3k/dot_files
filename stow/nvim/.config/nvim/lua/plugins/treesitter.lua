return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    local filetypes = { 'bash', 'c', 'cmake', 'cpp', 'diff', 'html', 'json', 'lua', 'markdown', 'python', 'xml', 'yaml' }
    require('nvim-treesitter').install(filetypes)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetypes,
      callback = function() vim.treesitter.start() end,
    })
  end
}
