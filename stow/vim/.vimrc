call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'w0ng/vim-hybrid'
Plug 'bling/vim-airline'
Plug 'qpkorr/vim-bufkill'
Plug 'Raimondi/delimitMate'
Plug 'JuliaLang/julia-vim'
Plug 'djoshea/vim-autoread'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
Plug 'Valloric/YouCompleteMe'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rhysd/vim-clang-format'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'derekwyatt/vim-fswitch'
call plug#end()

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

" Highlight past column 80
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=235

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif 

" Windowing commands
nnoremap <silent> <leader>q :bd<CR>
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <leader>mj <C-W>J
nnoremap <silent> <leader>mk <C-W>K
nnoremap <silent> <leader>ml <C-W>L
nnoremap <silent> <leader>mh <C-W>H
nnoremap <silent> <leader>nj :below new<CR>
nnoremap <silent> <leader>nk :above new<CR>
nnoremap <silent> <leader>nl :rightbelow vnew<CR>
nnoremap <silent> <leader>nh :leftabove vnew<CR>

" Buffer commands
nnoremap <c-p> :bp<CR>
nnoremap <c-n> :bn<CR>
nnoremap <leader>x :BW!<CR>

" Paste toggle command
set pastetoggle=<leader>p

" Other remaps
inoremap {<CR> {<CR>}<esc>O
vnoremap < <gv
vnoremap > >gv
noremap j gj
noremap k gk
noremap Y y$

" Don't automatically start a new comment on next line
inoremap <expr> <enter> getline('.') =~ '^\s*//' ? '<enter><esc>S' : '<enter>'
nnoremap <expr> O getline('.') =~ '^\s*//' ? 'O<esc>S' : 'O'
nnoremap <expr> o getline('.') =~ '^\s*//' ? 'o<esc>S' : 'o'

" To access UltiSnips directory with custom snippets
set rtp+=~/DotFiles

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

" -- vim-fugitive
nnoremap <leader>g :Gblame<CR>

" -- YouCompleteMe
let g:ycm_confirm_extra_conf = 0
nnoremap <F2> :YcmCompleter GoTo<CR>
nnoremap <F3> :YcmCompleter GetType<CR>
nnoremap <F4> :YcmCompleter FixIt<CR>

" -- fzf
nnoremap <leader><space> :Files<CR>
nnoremap <leader><Tab> :Buffers<CR>

" -- clang-format
let g:clang_format#detect_style_file = 1
nnoremap <leader>c :ClangFormat<CR>

" -- vim-startify
let g:startify_change_to_dir = 0

" -- Ultisnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"

" -- vim-fswitch
nmap <silent> <Leader>ff :FSHere<cr>
nmap <silent> <Leader>fl :FSRight<cr>
nmap <silent> <Leader>fh :FSLeft<cr>
nmap <silent> <Leader>fL :FSSplitRight<cr>
nmap <silent> <Leader>fH :FSSplitLeft<cr>
augroup fswitch_cpp
   au!
   au BufEnter *.h let b:fswitchdst  = 'cpp,hpp,cc,c'
   au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,reg:|include/\w\+|src|,impl'
   au BufEnter *.cpp let b:fswitchdst  = 'hpp,h'
   au BufEnter *.cpp let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,../include,reg:|src/\(\w\+\)/src|src/\1/include/**|'
   au BufEnter *.hpp let b:fswitchdst  = 'h,cpp'
   au BufEnter *.hpp let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,..'
augroup END
