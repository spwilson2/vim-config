""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This config file is intended to be useable on just about any machine with
" vim. It should not require anything installed on the machine besides a
" reasonably recent version of vim. (Late v7)
"
" Worthwhile sources:
"   https://github.com/amix/vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the key combo hang
set timeoutlen=200
set virtualedit=onemore " Let vim go past the last char.
set backspace=eol,start,indent " Rm endlines and indents
set foldlevel=99


" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
catch
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" History Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowritebackup
set noswapfile
set hidden

set history=100

set sessionoptions=curdir,folds,help,tabpages,winsize

" Persistent State for undos
try
    set undodir=~/.vim/tmp/undodir
    set undofile
catch
endtry

au BufReadPost * :call ReturnToLastLocation()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch
set ignorecase
set smartcase

set cscopetag   " use both cscope and ctag
set csto=0      " check cscope before checking ctags

set wildmenu " Use a matching menu for selecting files.

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

let g:netrw_liststyle=3 "netrw displays as tree by default, not single directory

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set modeline
set noerrorbells
set novisualbell
set guifont=Monospace\ 12
"Remove scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
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
set lazyredraw  " Dont' try to redraw while executing macros
set showtabline=2

hi SpecialKey guifg=red ctermfg=red
set listchars=tab:»·,trail:·
set list

" Dont' use the terminal background color
set t_ut=

set display=lastline

 " Move vertically earlier
set scrolloff=7

" Default colorscheme if no plugins.
try
    colorscheme desert
catch
endtry

set background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Hotkeys
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=" "

" Yank to clipboard
set clipboard=unnamedplus

" Yank line
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

" Close buffer without closing window
nnoremap <C-X> :Bclose<CR>
" Close the window
nnoremap <C-Q> :q<CR>

nnoremap <silent> <Leader>l     :setl invhls<cr><C-l>
nnoremap <silent> <Leader>h     :set invlist<CR>
nnoremap <silent> <Leader>sc    :setl invspell<CR>

" Tab navigation, with quick setup for next nav.
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [t :tabprevious<CR>

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

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Open a tab in the current file directory
nnoremap <leader>td :tabedit <C-R>=expand("%:p:h")<CR>/<CR>

" Open a tab of the same file in the same location
nnoremap <leader>te :call NewTab(expand('%'))<CR>

set pastetoggle=<F2>

" Reload all of vimrc
command! ReloadConfig exec 'source ' . expand('~/.vim/vimrc')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing white space on save, useful for some filetypes ;)
function! CleanWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

" Don't close window when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! ReturnToLastLocation()
    if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal! g`\""
    endif
endfunction

" Save position of cursor on open of this same tab.
function! NewTab(tab)
    let save_pos = getpos(".")
    exec 'tabe ' . a:tab
    call setpos('.', save_pos)
endfunction
