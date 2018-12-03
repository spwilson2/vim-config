set nocompatible
" {
if !empty(glob("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/plugged')

    Plug 'joshdick/onedark.vim'

    Plug 'itchyny/lightline.vim'

    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-eunuch'

    Plug 'w0rp/ale' " Async Linting
    Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py' } " Autocompletion simplified.
    "Plug 'rdnetto/YCM-Generator'

    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Useful if go to ctags, but doesn't work for global.
    "Plug 'xolox/vim-misc'
    "Plug 'xolox/vim-easytags'
    "Plug 'majutsushi/tagbar'
    Plug 'spwilson2/cscope_maps'

    Plug 'MattesGroeger/vim-bookmarks'
    Plug 'tpope/vim-surround'

    Plug 'tmhedberg/SimpylFold'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-scriptease'

    " Manage vim sessions (layouts, persist state)
    "
    " Use :Obsess (with optional file/directory name) to start recording to
    " a session file and :Obsess! to stop and throw it away.
    "
    " Load a session in the usual manner: vim -S, or :source it.
    Plug 'tpope/vim-obsession'


    "Plug 'tpope/vim-fugitive'
    "Plug 'airblade/vim-gitgutter'


    Plug 'rust-lang/rust.vim', { 'for': 'rust'}
    Plug 'racer-rust/vim-racer', { 'for': 'rust'}
    Plug 'fatih/vim-go', { 'for': 'go' }
    Plug 'chrisbra/csv.vim', { 'for': 'csv'}

    Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'javascript']}
    Plug 'Quramy/tsuquyomi', { 'for': ['typescript', 'javascript']}
    call plug#end()
else
    echom "Plugged can't be found"
endif
" } Plugged Setup

" TODO Refactor to source all
exec 'source ' . expand("~/.vim/local/whitespace.vim")
exec 'source ' . expand("~/.vim/local/font.vim")
exec 'source ' . expand("~/.vim/local/tags.vim")
exec 'source ' . expand("~/.vim/local/log.vim")
exec 'source ' . expand("~/.vim/local/filetypes.vim")

"""""""""""""""""""""""""""""""""""""""""""""""""""""
"               Plugin Settings                     {
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline {
function! s:lightline()
    set noshowmode
    function! LightlineReload()
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
    endfunction
    let g:lightline = {
      \     'active': {
      \         'left': [['mode', 'paste' ], ['readonly', 'filename', 'modified']],
      \         'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding']]
      \     }
      \ }
    function! HasPaste()
        if &paste
            return 'PASTE MODE '
        endif
        return ''
    endfunction
    " Always show the status line
    set laststatus=2
    " Format default status line
    "set statusline=\ %{HasPaste()}%.30F%m%r%h\ %w\ \ %{SyntasticStatuslineFlag()}\ %=Buf:\ [%n]\ %l,%c
    set showcmd " Show the chord in progress
endfunction
" Lightline }

function! s:youcompleteme()
    " if python 3 not working. Set the path.
    "let gycm_path_to_python_interpreter = '/usr/bin/python3'
    "let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_conf.py'
    " Disable to turn off asking about running files.
    " let g:ycm_confirm_extra_conf = 1
endfunction

function! s:nerdtree()
    " Tab to open nerdtree
    nnoremap <S-Tab> :NERDTreeToggle<CR>
    " Close if nerdtree is last buffer open
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endfunction

function! s:ctrlp()
    let g:ctrlp_max_files=200000
    command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw
     if executable('ag')
       " Use ag over grep
       set grepprg=ag\ --nogroup\ --nocolor
       let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
       " ag is fast enough that CtrlP doesn't need to cache
       let g:ctrlp_use_caching = 0
    endif
endfunction

function! s:vimgo()
    let g:go_version_warning = 0
endfunction

function! s:simplyfold()
    setl foldmethod=expr
endfunction

call s:simplyfold()
call s:lightline()
call s:youcompleteme()
call s:nerdtree()
"call s:ctrlp()
call s:vimgo()
" Plugin Settings }

"""""""""""""""""
"   General     {
"""""""""""""""""
set timeoutlen=400

set nobackup
set nowritebackup
set noswapfile

set hidden

set history=100

set sessionoptions=curdir,folds,help,tabpages,winsize

set clipboard=unnamedplus " Yanks to clipboard

set virtualedit=onemore " Let vim go past the last char.
set backspace=eol,start,indent " Rm endlines and indents

set wildmenu " Use a matching menu for selecting files.
let g:netrw_liststyle=3 "netrw displays as tree by default, not single directory

set scrolloff=7 " Move vertically earlier
set foldlevel=99

" Search opts
set incsearch
set ignorecase
set smartcase

set cscopetag   " use both cscope and ctag
set csto=0      " check cscope before checking ctags

" Visual opts
set modeline
set noerrorbells
set novisualbell
set guioptions-=m  " remove menu bar
set guioptions-=T  " remove toolbar
set guioptions+=k  " Resize the gui when gui elements are added/removed
set guioptions+=c  " Simple dialogs, not annoying popups
set guioptions+=e  " Use fancy tabs
set showmatch   " Show matching brackets
set number      " Show line numbers
set ruler       " Always show ruler
set wrap        " Wrap lines
syntax enable   " Enable syntax highlighting

hi SpecialKey guifg=red ctermfg=red
set listchars=tab:»·,trail:·
set list
colorscheme onedark
set background=dark

set t_ut=        " Clear the background so print is fresh

set display=lastline

"""""""""""""""""""""
" General Functions {
"""""""""""""""""""""
function! BufClose()
    sbprevious
    wprevious
    bdelete
endfunction

function! ReturnToLastLocation()
    if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal! g`\""
    endif
endfunction

function! ToggleSidebar()
    set invnumber
endfunction

" Fold manually more easily
function! NaturalFold()
    try
        normal zc
        echom "Closing fold"
    catch E490
        normal zf%
        echom "Creating fold"
    endtry
endfunction
" Initialization which needs to take place a little time in the future so other
" plugins don't override.
function! PostInitSetup(timer)
    " Insert tab, YCM overrides the hotkey
    inoremap <S-Tab> <C-V><Tab>
endfunction

" TODO Change this so it doesn't break when timer_start doesn't exist. Also
" needs to be made mroe consistent.
let _timer = timer_start(100, 'PostInitSetup', {})
"""""""""""""""""""""
" General Functions }
"""""""""""""""""""""

"""""""""""""
" Hotkeys   {
"""""""""""""
let mapleader=" "

nnoremap Y y$

"%% is maped to the directory of %
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" Emacs command mode editing
execute "set <M-d>=\ed"
execute "set <M-b>=\eb"
execute "set <M-f>=\ef"
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <M-d> <S-Right><C-w>

nnoremap <C-Q> :q<CR>
" Delete buffer without closing the window
nnoremap <C-X> :b#<bar>bd#<CR>

nnoremap <silent> <Leader>l     :setl invhls<cr><C-l>
nnoremap <silent> <Leader>h     :set invlist<CR>
nnoremap <silent> <Leader>sc    :setl invspell<CR>

" Tab navigation
nnoremap t gt
nnoremap T gT

" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Buffer navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" Toggle linenumbers.
nnoremap <C-N> :call ToggleSidebar()<CR>

set pastetoggle=<F2>

" Folding
nnoremap <leader>f :call NaturalFold()<CR>
nnoremap <leader>o zo
" Hotkeys   }
