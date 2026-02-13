-- Options and keymaps
require 'core.options'
require 'core.keymaps'
require 'core.autocommand'

-- Install lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Set up plugins
require('lazy').setup({
  require 'plugins.colorscheme',
  require 'plugins.bufferline',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.tmux',
  require 'plugins.gitsigns',
  require 'plugins.neogen',
  require 'plugins.alpha',
})
