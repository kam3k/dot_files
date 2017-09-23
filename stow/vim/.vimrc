call plug#begin('~/.vim/plugged')
Plug 'w0ng/vim-hybrid' " Colorscheme
Plug 'cocopon/lightline-hybrid.vim' " Lightline vim-hybrid
Plug 'qpkorr/vim-bufkill' " Kill buffers well
Plug 'jiangmiao/auto-pairs' " Auto-handling of brackets, etc.
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
Plug 'tpope/vim-commentary' " Easily comment / uncomment blocks
Plug 'skywind3000/asyncrun.vim' " Run commands / builds in background 
Plug 'szw/vim-maximizer' " Temporarily maximize a pane
Plug 'tpope/vim-sensible' " Sensible default settings
Plug 'christoomey/vim-tmux-navigator' " Seamless navigation between vim and tmux
Plug 'itchyny/lightline.vim' " Status line plugin
Plug 'TxHawks/tmuxline.vim', { 'branch': 'patch-1' } " Make tmux look like vim colorscheme
call plug#end()

" Settings
set hidden " allow unsaved buffers to be hidden
set showmode " shows the mode (insert, visual, normal) at bottom
set bs=2 " allow backspace over anything in insert mode
set mouse=a " mouse use enabled
set splitright " new vertical splits go to the right
set splitbelow " new horizontal splits go below
set nostartofline " keep cursor in same column for long-range motion cmds
set ignorecase " ignore case when using a search pattern
set smartcase " override 'ignorecase' when pattern has upper case character
set tabstop=4 " tab is four spaces
set shiftwidth=4 " number of spaces indented using >> and << commands
set expandtab " tab inserts spaces instead of tabs
set softtabstop=4 " always uses spaces, never tabs
set number " show line numbers
set relativenumber " line numbers relative to cursor
set updatetime=250 " 250 ms between screen updates

" Filetype and syntax
autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype cpp setlocal ts=2 sts=2 sw=2

" Appearance
set background=dark
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" Windowing commands
nnoremap <leader>q :bd<CR>
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <leader>mj :below new<CR>
nnoremap <silent> <leader>mk :above new<CR>
nnoremap <silent> <leader>ml :rightbelow vnew<CR>
nnoremap <silent> <leader>mh :leftabove vnew<CR>
nnoremap <silent> <leader>MJ <C-W>J
nnoremap <silent> <leader>MK <C-W>K
nnoremap <silent> <leader>ML <C-W>L
nnoremap <silent> <leader>MH <C-W>H

" Buffer commands
nnoremap <c-p> :bp<CR>
nnoremap <c-n> :bn<CR>
nnoremap <leader>x :BW!<CR>
nnoremap <leader>X :bufdo bd<CR>

" Paste toggle command
set pastetoggle=<leader>v

" Other remaps
vnoremap < <gv
vnoremap > >gv
noremap j gj
noremap k gk
noremap Y y$
nnoremap <leader>* ciw/*<C-R>"*/<Esc>
vnoremap <leader>* c/*<C-R>"*/<Esc>
nnoremap <leader>8 F/xxf*xx<Esc>
nnoremap <leader>s O/**<space><space>*/<Esc>F<space>i

" Never automatically continue comment when starting next line
au FileType * set fo-=c fo-=r fo-=o

" clang-format
map <leader>c :py3f ~/.clang-format.py<CR>

" Search for name of current file
nnoremap <leader>h :Ag <C-R>=expand('%:t')<CR><CR>

" Close preview window when leaving insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN RELATED
"""""""""""""""""""""""""""""""""""""""""""""""""""""
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
let g:ycm_always_populate_location_list = 1
nnoremap <leader>t :YcmCompleter GetType<CR>
nnoremap ]e :lnext<CR>
nnoremap [e :lprevious<CR>

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

" -- vim-fswitch
nmap <silent> <leader>ff :FSHere<CR>
nmap <silent> <leader>fl :FSRight<CR>
nmap <silent> <leader>fh :FSLeft<CR>
nmap <silent> <leader>fL :FSSplitRight<CR>
nmap <silent> <leader>fH :FSSplitLeft<CR>
let g:fsnonewfiles = 'on'
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

" -- asyncrun
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

" -- vim-maximizer
nnoremap <c-b>z :MaximizerToggle<CR>

" -- vim-commentary
augroup FTOptions 
    autocmd!
    autocmd FileType c,cpp  setlocal commentstring=//\ %s
    autocmd FileType cmake  setlocal commentstring=#\ %s
augroup END

" -- lightline
let g:lightline = {
        \ 'colorscheme': 'hybrid',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'asyncrun_status' ] ] 
        \ },
        \ 'inactive': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'asyncrun_status' ] ] 
        \ },
        \ 'component': {
        \   'lineinfo': ' %3l:%-2v',
        \   'asyncrun_status': '%{g:asyncrun_status}'
        \ },
        \ 'component_function': {
        \   'readonly': 'LightlineReadonly',
        \   'fugitive': 'LightlineFugitive',
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' }
        \ }

function! LightlineReadonly()
        return &readonly ? '' : ''
endfunction

" This function is taken from vim-airline, to shorten
" the branch name when appropriate.
function! LightlineShorten(text, winwidth, minwidth, ...)
  if winwidth(0) < a:winwidth && len(split(a:text, '\zs')) > a:minwidth
    if get(a:000, 0, 0)
      " shorten from tail
      return '…'.matchstr(a:text, '.\{'.a:minwidth.'}$')
    else
      " shorten from beginning of string
      return matchstr(a:text, '^.\{'.a:minwidth.'}').'…'
    endif
  else
    return a:text
  endif
endfunction

" Show git branch
function! LightlineFugitive()
        if exists('*fugitive#head')
                let branch = fugitive#head(7)
                let branch = branch !=# '' ? ' '.branch : ''
                return LightlineShorten(branch, 120, 15)
        endif
        return ''
endfunction

" -- tmuxline
let g:tmuxline_preset = 'minimal'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" SOURCE LOCAL VIM CONFIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    source ~/.local.vim
catch
    " no local file, ignore
endtry
