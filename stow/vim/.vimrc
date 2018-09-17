" Install vim-plug if it isn't installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'ap/vim-buftabline' " Show buffers in tabline
Plug 'mhinz/vim-sayonara' " Kill buffers well
Plug 'jiangmiao/auto-pairs' " Auto-handling of brackets, etc.
Plug 'djoshea/vim-autoread' " Auto-reload buffers that have been changed elsewhere
Plug 'airblade/vim-gitgutter' " Show git status of lines in gutter
Plug 'tpope/vim-fugitive' " Git functionality in vim
Plug 'Valloric/YouCompleteMe' " Autocomplete and much more
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy search
Plug 'junegunn/fzf.vim' " Vim bindings to various fuzzy searches
Plug 'lyuts/vim-rtags', { 'commit': '8773238cdc2570ffa81aac18138dc773ff3e92d3' } " Tags to jump around code and find symbols
Plug 'mrtazz/DoxygenToolkit.vim' " Auto-insert Doxygen comments
Plug 'tpope/vim-commentary' " Easily comment / uncomment blocks
Plug 'skywind3000/asyncrun.vim' " Run commands / builds in background 
Plug 'szw/vim-maximizer' " Temporarily maximize a pane
Plug 'christoomey/vim-tmux-navigator' " Seamless navigation between vim and tmux
Plug 'w0rp/ale' " Asynchronous linting
Plug 'chriskempson/base16-vim' " Colorschemes
Plug 'sheerun/vim-polyglot' " Better syntax highlighting
Plug 'xolox/vim-misc' " Dependency of vim-session
Plug 'xolox/vim-session' " Session management
Plug 'mhinz/vim-startify' " Fancy start screen
Plug 'RRethy/vim-illuminate' " Highlight other occurrences of words
Plug 'Asheq/close-buffers.vim' " Close hidden buffers easily
call plug#end()

" Status line
set laststatus=2
set statusline=
if !empty(glob("~/.vim/plugged/vim-session"))
  set statusline+=\ %{xolox#session#find_current_session()}
endif
set statusline+=\ %=
set statusline+=\ %{g:asyncrun_status}

" Settings
set hidden " allow unsaved buffers to be hidden
set bs=2 " allow backspace over anything in insert mode
set mouse=a " mouse use enabled
set splitright " new vertical splits go to the right
set splitbelow " new horizontal splits go below
set nostartofline " keep cursor in same column for long-range motion cmds
set ignorecase " ignore case when using a search pattern
set smartcase " override 'ignorecase' when pattern has upper case character
set tabstop=2 " tab is four spaces
set shiftwidth=2 " number of spaces indented using >> and << commands
set expandtab " tab inserts spaces instead of tabs
set softtabstop=2 " always uses spaces, never tabs
set number " show line numbers
set updatetime=250 " 250 ms between screen updates
set noshowmode " don't show mode (just look at cursor)
set wildmode=list:longest,full " list completions on command line, cycle through with tab

" Different cursors in insert and normal mode
let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[5 q"
let &t_EI = "\<esc>[2 q"

" Colorscheme
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Windowing commands
nnoremap <leader>q :Sayonara<CR>
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <leader>wj :below new<CR>
nnoremap <silent> <leader>wk :above new<CR>
nnoremap <silent> <leader>wl :rightbelow vnew<CR>
nnoremap <silent> <leader>wh :leftabove vnew<CR>
nnoremap <silent> <leader>mj <C-W>J
nnoremap <silent> <leader>mk <C-W>K
nnoremap <silent> <leader>ml <C-W>L
nnoremap <silent> <leader>mh <C-W>H

" Buffer commands
nnoremap <c-p> :bp<CR>
nnoremap <c-n> :bn<CR>
nnoremap <leader>x :Sayonara!<CR>
nnoremap <silent> Q :CloseBuffersMenu<CR>

" Paste toggle command
set pastetoggle=<leader>v

" Other remaps
vnoremap < <gv
vnoremap > >gv
noremap j gj
noremap k gk
noremap Y y$
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
nmap g; g;zz
nnoremap <leader>* ciw/*<C-R>"*/<Esc>
vnoremap <leader>* c/*<C-R>"*/<Esc>
nnoremap <F8> F/xxf*xx<Esc>

" Never automatically continue comment when starting next line
au FileType * set fo-=c fo-=r fo-=o

" clang-format
map <leader>c :py3f ~/.clang-format.py<CR>

" Search for name of current file
nnoremap <leader>h :Ag <C-R>=expand('%:t')<CR><CR>

" Disable preview window on completions
set completeopt-=preview

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN RELATED
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" -- vim-fugitive
nnoremap <leader>gb :Gblame<CR>

" -- YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1
nnoremap <leader>yt :YcmCompleter GetType<CR>
nnoremap <leader>yf :YcmCompleter FixIt<CR>

" -- fzf
nnoremap <leader>o :Files<CR>
nnoremap <leader>i :Buffers<CR>
nnoremap <leader>/ :Lines<CR>
nnoremap <leader>a :Ag<space>
nnoremap <leader>p :History<CR>
nnoremap <leader>: :History:<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""' " ignore files in .gitignore
let g:fzf_layout = { 'down': '~40%' }

function! FZFSameName(sink, pre_command, post_command)
    let current_file_no_extension = expand("%:t:r")
    let current_file_with_extension = expand("%:t")
    execute a:pre_command
    call fzf#run(fzf#wrap({
          \ 'source': 'find -name ' . current_file_no_extension . '.* | grep -Ev *' . current_file_with_extension . '$',
          \ 'options': -1, 'sink': a:sink}))
    execute a:post_command
endfunction
nnoremap <leader>ff :call FZFSameName('e', '', '')<CR>
nnoremap <leader>fh :call FZFSameName('e', 'wincmd h', '')<CR>
nnoremap <leader>fl :call FZFSameName('e', 'wincmd l', '')<CR>
nnoremap <leader>fk :call FZFSameName('e', 'wincmd k', '')<CR>
nnoremap <leader>fj :call FZFSameName('e', 'wincmd j', '')<CR>
nnoremap <leader>fH :call FZFSameName('leftabove vsplit', '', 'wincmd h')<CR>
nnoremap <leader>fL :call FZFSameName('rightbelow vsplit', '', 'wincmd l')<CR>
nnoremap <leader>fK :call FZFSameName('leftabove split', '', 'wincmd k')<CR>
nnoremap <leader>fJ :call FZFSameName('rightbelow split', '', 'wincmd j')<CR>

" -- DoxygenToolkit.vim
nnoremap <leader>dd :Dox<CR>
nnoremap <leader>ds O/**<space><space>*/<Esc>F<space>i

" -- asyncrun
map <F11> :AsyncStop<CR>
noremap <leader><leader> :call asyncrun#quickfix_toggle(15)<CR>
augroup vimrc
    autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(15, 1)
augroup END
fun! OnAsyncRunExit()
    if g:asyncrun_status == 'success'
		call asyncrun#quickfix_toggle(15, 0)
    endif
endf
let g:asyncrun_exit = "call OnAsyncRunExit()"
let g:asyncrun_status = "stopped"
augroup QuickfixStatus
	au! BufWinEnter quickfix setlocal 
		\ statusline=%t\ [%{g:asyncrun_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
augroup END

" -- vim-maximizer
nnoremap <c-b>z :MaximizerToggle<CR>

" -- vim-commentary
augroup FTOptions 
    autocmd!
    autocmd FileType c,cpp  setlocal commentstring=//\ %s
    autocmd FileType cmake  setlocal commentstring=#\ %s
augroup END

" -- buftabline
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)
hi! link BufTabLineCurrent Search
hi! link BufTabLineHidden Folded
hi! link BufTabLineActive DiffAdd

" -- ale
let g:ale_linters = {
            \   'cpp': ['clangtidy'],
            \}
let g:ale_cpp_clangtidy_checks = ['clang-analyzer-*', 'modernize-*', 'performance-*', 'readability-*', 'cppcoreguidelines-*']
let g:ale_set_highlights = 0
" Set up mapping to move between errors
nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)

" -- vim-session
set sessionoptions-=help
set sessionoptions-=options
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:session_autosave_periodic = 1
let g:session_autosave_silent = 1
nmap <leader>so :OpenSession<CR>
nmap <leader>ss :SaveSession 
nmap <leader>sd :DeleteSession<CR>
nmap <leader>sq :CloseSession!<CR>

" -- Startify
let g:startify_session_dir = '~/.vim/sessions'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" SOURCE LOCAL VIM CONFIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    source ~/.local.vim
catch
    " no local file, ignore
endtry
