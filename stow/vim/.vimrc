call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim' " Colorschemes
Plug 'bling/vim-airline' " Pretty and useful status line
Plug 'vim-airline/vim-airline-themes' " Airline themes
Plug 'qpkorr/vim-bufkill' " Kill buffers well
Plug 'Raimondi/delimitMate' " Auto-close brackets, parentheses, etc.
Plug 'djoshea/vim-autoread' " Auto-reload buffers that have been changed elsewhere
Plug 'airblade/vim-gitgutter' " Show git status of lines in gutter
Plug 'tpope/vim-fugitive' " Git functionality in vim
Plug 'mhinz/vim-startify' " Useful start screen
Plug 'Valloric/YouCompleteMe' " Autocomplete and much more
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy search
Plug 'junegunn/fzf.vim' " Vim bindings to various fuzzy searches
Plug 'derekwyatt/vim-fswitch' " Switch between source and headers
Plug 'octol/vim-cpp-enhanced-highlight' " Better highlighting in c++
Plug 'lyuts/vim-rtags' " Tags to jump around code and find symbols
Plug 'mrtazz/DoxygenToolkit.vim' " Auto-insert Doxygen comments
Plug 'christoomey/vim-tmux-navigator' " Seamless navigation between vim and tmux
Plug 'edkolev/tmuxline.vim' " Make tmux look like vim colorscheme
Plug 'tpope/vim-commentary' " Easily comment / uncomment blocks
Plug 'benekastah/neomake' " Used to call clang-tidy
Plug 'terryma/vim-smooth-scroll' " Vim scrolls smoothly
Plug 'justinmk/vim-sneak' " Simple motion command
Plug 'dominickng/fzf-session.vim' " Session management
Plug 'junegunn/vim-peekaboo' " View registers automatically
Plug 'kshenoy/vim-signature' " View/manage marks
Plug 'Alok/notational-fzf-vim' " Note-taking / journal
call plug#end()

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
set relativenumber " line numbers relative to cursor
set laststatus=2 " always show status line
set updatetime=250 " 250 ms between screen updates

" Filetype and syntax
autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype cpp setlocal ts=2 sts=2 sw=2

" Appearance
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
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
set pastetoggle=<leader>v

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

" clang-format
map <leader>c :py3f ~/.clang-format.py<CR>

" search for name of current file
nnoremap <leader>h :Ag <C-R>=expand('%:t')<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN RELATED
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" -- Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_section_warning = ''
let g:airline_theme = 'base16'
let g:airline_section_b = '%{getcwd()}'
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = '%c'
let g:airline_section_error = ''
let g:airline_section_warning = ''

" -- vim-fugitive
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gp :Gpush<CR>

" -- YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_highlighting = 0
nnoremap <leader>t :YcmCompleter GetType<CR>

" -- fzf
nnoremap <leader>o :Files<CR>
nnoremap <leader>i :Buffers<CR>
nnoremap <leader>a :Ag<space>
nnoremap <leader>p :History<CR>
nnoremap <leader>: :History:<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""' " ignore files in .gitignore
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%', '?'),
  \                 <bang>0)
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" -- vim-startify
let g:startify_change_to_dir = 0
nnoremap <leader>s :Startify<CR>

" -- vim-fswitch
nmap <silent> <leader>ff :FSHere<CR>
nmap <silent> <leader>fl :FSRight<CR>
nmap <silent> <leader>fh :FSLeft<CR>
nmap <silent> <leader>fL :FSSplitRight<CR>
nmap <silent> <leader>fH :FSSplitLeft<CR>
augroup fswitch_cpp
   au!
   au BufEnter *.h let b:fswitchdst  = 'cpp,hpp,cc,c'
   au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,reg:|include/\w\+|src|,impl'
   au BufEnter *.cpp let b:fswitchdst  = 'hpp,h'
   au BufEnter *.cpp let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,../include,reg:|src/\(\w\+\)/src|src/\1/include/**|'
   au BufEnter *.hpp let b:fswitchdst  = 'h,cpp'
   au BufEnter *.hpp let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,..'
augroup END

" -- vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1

" -- DoxygenToolkit.vim
nnoremap <leader>d :Dox<CR>

" -- tmuxline
let g:tmuxline_preset = 'minimal'

" -- neomake
let g:neomake_cpp_enabled_makers = ['clangtidy']
let g:neomake_cpp_clangtidy_maker = {
   \ 'exe': '/usr/local/bin/clang-tidy',
   \ 'args': ['-checks=-*,modernize-*,cppcoreguidelines-*,performance-*,readability-*,google-*,misc-*'],
   \}
nnoremap <leader>n :Neomake<CR>

" -- vim-smooth-scroll
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>

" -- fzf-session.vim
let g:fzf_session_path = '~/.vim/session'
nnoremap <leader>sn :Session<space>
nnoremap <leader>sq :SQuit<CR>
nnoremap <leader>ss :Sessions<CR>

" -- vim-signature
let g:SignatureMarkTextHL = 1

" -- notational-fzf-vim
let g:nv_directories = ['~/.notes']
let g:nv_use_short_pathnames = 1
let g:nv_wrap_preview_text = 1
let g:nv_create_note_window = 'e'
nnoremap <leader>nv :NV<CR>
