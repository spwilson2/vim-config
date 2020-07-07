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

" Don't change the EOF
set nofixendofline
" Don't add an extra space on join of strings
set nojoinspaces

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,newtab
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

" Automatically update files when they change outside the editor.
set autoread

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
"if has("win16") || has("win32")
"    set wildignore+=.git\*,.hg\*,.svn\*
"else
"    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
"endif

let g:netrw_liststyle=3 "netrw displays as tree by default, not single directory

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set modeline
set noerrorbells
set novisualbell
set guifont=Monospace\ 9
set termguicolors " Enable true color support
set cursorline " Highlight the current line
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
set mouse=a
set showmatch   " Show matching brackets
set relativenumber  " Show line numbers
set ruler       " Always show ruler
set wrap        " Wrap lines
syntax enable   " Enable syntax highlighting
set lazyredraw  " Dont' try to redraw while executing macros
set showtabline=2
set updatetime=500

hi SpecialKey guifg=red ctermfg=red
set listchars=tab:»·,trail:·
set nolist

" Dont' use the terminal background color
"set t_ut=

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

" Close buffer without closing window
nnoremap <C-X> :Bclose<CR>
" Close the window
nnoremap <C-Q> :Bclose<CR>:q<CR>

nnoremap <silent> <Leader>h     :setl invhls<cr><C-l>
nnoremap <silent> <Leader>l     :call ToggleShowColumn()<CR>
nnoremap <silent> <Leader>w     :setl invlist<CR>
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

" jk | Escaping!
inoremap jk <Esc>  
xnoremap jk <Esc>
cnoremap jk <C-c>
nnoremap jkq <Esc>:q<CR>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

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


if has("nvim")
    tnoremap <C-W>
    augroup termopen
        au!
        autocmd TermOpen * startinsert
        tnoremap <a-a> <esc>a
        tnoremap <a-b> <esc>b
        tnoremap <a-d> <esc>d
        tnoremap <a-f> <esc>f
    augroup END
else
    " Prefer using popups over previews for completion options.
    set completeopt+=popup 
endif

" ----------------------------------------------------------------------------
" Readline-style key bindings in command-line (excerpt from rsi.vim)
" ----------------------------------------------------------------------------
cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap        <M-b> <S-Left>
cnoremap        <M-f> <S-Right>
silent! exe "set <S-Left>=\<Esc>b"
silent! exe "set <S-Right>=\<Esc>f"

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

" Change line numbers
" Based on: jeffkreeftmeijer/vim-numbertoggle
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

function! ToggleSidebar()
    if !exists("g:ToggleSidebar#init")
        let g:ToggleSidebar#type_num = &number
        let g:ToggleSidebar#type_relnum = &relativenumber
        let g:ToggleSidebar#auto_signcolumn = (&signcolumn == 'auto')
    endif
    let g:ToggleSidebar#init = "true"

    if g:ToggleSidebar#type_num
        set invnumber
    endif
    if g:ToggleSidebar#type_relnum
        set invrelativenumber
    endif

    if &signcolumn == 'auto' || (&signcolumn == 'yes' && g:ToggleSidebar#auto_signcolumn)
        set signcolumn=no
    else
        if g:ToggleSidebar#auto_signcolumn
            set signcolumn=auto
        else
            set signcolumn=yes
        endif
    endif
endfunction

function! ToggleShowColumn()
    let l:show_column=get(b:, 'next_show_column', "true")

    if l:show_column == "true"
        exec ':setl colorcolumn=' . &textwidth
        let b:next_show_column="false"
    else
        exec ':setl colorcolumn='
        let b:next_show_column="true"
    endif
endfunction

" Save position of cursor on open of this same tab.
function! NewTab(tab)
    let save_pos = getpos(".")
    exec 'tabe ' . a:tab
    call setpos('.', save_pos)
endfunction

function! DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call DiffWithSaved()

" Redirect the output of a Vim or external command into a scratch buffer
function! Redir(cmd) abort
    let output = execute(a:cmd)
    tabnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 Redir silent call Redir(<f-args>)
