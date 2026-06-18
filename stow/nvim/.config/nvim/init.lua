vim.cmd.colorscheme("sora")
vim.o.number = true -- enable line numbers
vim.o.statusline = "%f %m %r %= %l:%c" -- filename, modified, readonly, push to right, line and col number
vim.o.wrap = false -- don't wrap lines
vim.o.autoindent = true -- copy indent from current line when starting a new one
vim.o.ignorecase = true -- case insensitive search
vim.o.smartcase = true -- case sensitive search when including a capital
vim.o.shiftwidth = 2 -- number of spaces inserted for indentation
vim.o.tabstop = 2 -- number of spaces inserted when pressing tab
vim.o.softtabstop = 2 -- number of spaces inserted when pressing tab
vim.o.expandtab = true -- convert tab to spaces
vim.o.undofile = true -- save undo history
vim.o.signcolumn = 'yes' -- keep signcolumn on by default
vim.o.updatetime = 250 -- decrease update time
vim.o.timeoutlen = 500 -- time to wait for a mapped sequence to complete (milliseconds)
vim.o.completeopt = 'menuone,noselect' -- show popup with one match, do not insert until selected, fuzzy matching
vim.o.termguicolors = true -- enable highlight groups
vim.o.scrolloff = 4 -- minimum number of lines to keep above/below cursor
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.showmode = false -- do not show mode
vim.o.hlsearch = true -- highlight searches
vim.o.incsearch = true -- incrementally highlight searches
