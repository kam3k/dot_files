" The below is required for Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Plugin 'gmarik/vundle'

" Vundle bundles
Plugin 'scrooloose/nerdtree'
Plugin 'w0ng/vim-hybrid'
Plugin 'bling/vim-airline'
Plugin 'qpkorr/vim-bufkill'
Plugin 'Raimondi/delimitMate'
Plugin 'JuliaLang/julia-vim'
Plugin 'djoshea/vim-autoread'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'mhinz/vim-startify'
Plugin 'Valloric/YouCompleteMe'

" Filetype and syntax
syntax on
filetype plugin indent on
autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype cpp setlocal ts=2 sts=2 sw=2
autocmd Filetype julia setlocal ts=2 sts=2 sw=2

" Settings
set shell=/bin/sh " syntastic doesn't work with fish!
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
set cursorline " highlight current line occupied by cursor
set cursorcolumn " highlight current column occupied by cursor
set updatetime=250 " 250 ms between screen updates

" Appearance
silent! colorscheme hybrid " bundle must be installed
set background=dark
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif 

" Change cursor shape between insert and normal mode in gnome-terminal
if has("autocmd")
  au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
  au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
endif

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

" Buffer commands
nnoremap <c-p> <c-^>
nnoremap <c-i> :bp<CR>
nnoremap <c-o> :bn<CR>
nnoremap <c-x> :BW<CR>

" Paste toggle command
set pastetoggle=<F2>

" Other remaps
inoremap {<CR> {<CR>}<esc>O
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
nnoremap <Leader>" o""""""<esc>hhi
vnoremap < <gv
vnoremap > >gv
noremap j gj
noremap k gk
noremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN RELATED
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" -- NERDTree
nnoremap <c-f> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks = 1
let NERDTreeChDirMode = 2
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeQuitOnOpen = 1

" -- Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" -- julia-vim
let g:latex_to_unicode_auto = 1
runtime macros/matchit.vim

" -- YouCompleteMe
let g:ycm_confirm_extra_conf = 0
