local opts = { noremap = true, silent = true} -- options for all keymaps

-- Window navigation
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<CR>', opts)
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<CR>', opts)
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<CR>', opts)
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<CR>', opts)

-- Close window
vim.keymap.set('n', '<leader>q', '<cmd>q!<CR>', opts)

-- New windows
vim.keymap.set('n', '<leader>wh', '<cmd>leftabove vnew<CR>', opts)
vim.keymap.set('n', '<leader>wj', '<cmd>below new<CR>', opts)
vim.keymap.set('n', '<leader>wk', '<cmd>above new<CR>', opts)
vim.keymap.set('n', '<leader>wl', '<cmd>rightbelow vnew<CR>', opts)

-- Move windows
vim.keymap.set('n', '<leader>mh', '<cmd>wincmd H<CR>', opts)
vim.keymap.set('n', '<leader>mj', '<cmd>wincmd J<CR>', opts)
vim.keymap.set('n', '<leader>mk', '<cmd>wincmd K<CR>', opts)
vim.keymap.set('n', '<leader>ml', '<cmd>wincmd L<CR>', opts)

-- Close buffer
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', opts)

-- Centre cursor on vertical scroll
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Centre cursor on next and previous search result
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in visual mode when indenting so you can keep indenting
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)
