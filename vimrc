" The below is required for Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

" Vundle bundles
Bundle 'sandeepcr529/Buffet.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'jiangmiao/auto-pairs'
Bundle 'w0ng/vim-hybrid'
Bundle 'davidhalter/jedi-vim'
Bundle 'ervandew/supertab'
Bundle 'JuliaLang/julia-vim'
Bundle 'bling/vim-airline'

" Filetype and syntax
syntax on
filetype plugin indent on

" Settings
set rnu " relative numbering
set hidden " allow unsaved buffers to be hidden
set showmode " shows the mode (insert, visual, normal) at bottom
set wildmenu " better ex mode with autocomplete
set completeopt=menu,menuone,longest " don't auto-insert item (longest), show menu even for one item (menuone)
set bs=2 " allow backspace over anything in insert mode
set mouse=a " mouse use enabled
set splitright " new vertical splits go to the right
set splitbelow " new horizontal splits go below
set incsearch " search as you type
set nostartofline " keep cursor in same column for long-range motion cmds
set ignorecase " ignore case when using a search pattern
set smartcase " override 'ignorecase' when pattern has upper case character
set autoread " Automatically re-read files changed outside of vim
set tabstop=4 " tab is four spaces
set shiftwidth=4 " number of spaces indented using >> and << commands
set expandtab " tab inserts spaces instead of tabs
set autoindent " automatically indent previous line's indent
set softtabstop=4 " always uses spaces, never tabs
set scrolloff=5 " scroll limit number of rows from top/bottom
set number " show line numbers
set laststatus=2 " always show status line

" Appearance
silent! colorscheme hybrid
hi MatchParen gui=bold guifg=magenta

" Windowing commands
nnoremap <silent> <c-q> <c-w>q
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <leader>mj <C-W>J
nnoremap <silent> <leader>mk <C-W>K
nnoremap <silent> <leader>ml <C-W>L
nnoremap <silent> <leader>mh <C-W>H

" Other remaps
nnoremap <c-p> <c-^>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
inoremap <c-enter> <esc>o
inoremap <c-s-enter> <esc>A;<CR>
vnoremap < <gv
vnoremap > >gv
noremap j gj
noremap k gk
noremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAC ONLY
"""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('mac')
    set guifont=Menlo:h12
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN RELATED
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" -- NERDTree
nnoremap <c-f> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks = 1
let NERDTreeChDirMode = 2
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeQuitOnOpen = 1

" -- Buffet
nnoremap <c-b> :Bufferlist<CR>

" -- Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" -- Airline
let g:airline#extensions#tabline#enabled = 1
