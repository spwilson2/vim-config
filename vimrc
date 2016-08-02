" Vi IMproved
set nocompatible

filetype plugin indent on
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `General Settings`      --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Space is leader key
let mapleader=" "

" Turn backup off
set nobackup
set nowritebackup
set noswapfile

" No annoying sound on errors
set noerrorbells
set novisualbell

" Set the number of undos
set history=100

" Let vim go past the last char.
set virtualedit=onemore

" Configure backspace to remove endlines and indents
set backspace=eol,start,indent

" Allow traveling between buffers without the error prompt (liberally hides buffers)
set hidden

" Disable vim modeline reading (for security).
set nomodeline

" Always use *nix line endings.
set fileformats=unix,dos
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-----------    `Defualt Filetype Config`       --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set linebreak
set textwidth=79
set formatoptions=tcrqj1
set foldmethod=manual

""""""""""""""""""""
"""  => Tabs    """"
""""""""""""""""""""
set shiftwidth=4   " Width for > and < vcmds
set tabstop=4      " Visual length of tabs
set softtabstop=4  " Length to use spaces at instead of tabs
set expandtab      " Use spaces instead of tabs
set smarttab       " Tab to previous set lines
set autoindent     " Auto indent following lines

""""""""""""""""""""
"""  Searches   """"
""""""""""""""""""""
" When searching try to be smart about cases
set ignorecase
set smartcase
set incsearch

" Toggle highlight
noremap <silent> <Leader>l :set invhls<cr><C-l>
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Functions`       --------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Preserves the previous state after running a command
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    en
    return ''
endfunction

function! ReturnToLastLocation()
    if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal! g`\""
    endif
endfunction
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Hotkeys`       ----------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the toggle for pastemode to <F2>
set pastetoggle=<F2>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy
nnoremap Y y$

" Manually regen ctags
nnoremap <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Toggle Spell Check.
nnoremap <Leader>sc :set invspell<CR>

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
nnoremap <C-N> :set invnumber<CR>

nnoremap <Leader>sc :set invspell<CR>

" Remove the Windows ^M
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" %% can be used to get the directory of the file in the current buffer.
"cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Remove trailing whitespace and preserve the previous search pattern
nnoremap _$ :call Preserve("%s/\\s\\+$//e")<CR>

"%% is maped to the directory of % (The active buffer)
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
" Edit from current file directory
map <leader>ew :e %%
" Split from current file dir
map <leader>es :sp %%
" VSplit from current file dir
map <leader>ev :vsp %%
" Tab from currrent file dir
map <leader>et :tabe %%

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

nnoremap <leader>f :call NaturalFold()<CR>
nnoremap <leader>o zo

"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Visuals`       ----------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch   " Show matching brackets
set number      " Show line numbers
set ruler       " Always show ruler
set wrap        " Wrap lines

syntax enable   " Enable syntax highlighting

" Color setting
colorscheme zellner
"colorscheme zenburn

" Move vertically earlier
set so=7

set foldlevel=99       " Disable automatic folding

""""""""""""""""""""""""""""""""""""
""""    `Status Line`           "{{{
""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%.30F%m%r%h\ %w\ \ cwd:\ %{getcwd()}\ \ \ %=Buf:\ [%n]\ %l,%c

" Show the command in progress at bottom.
set showcmd
"}}} -------------------------------
"}}} ==============================================================
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Misc`       -------------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set whichwrap+=<,>",h,l
"Clear the background
set t_ut=

"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Filetypes`       --------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The general plain text file setup
function! PlainFilyetypeConfig()
    setlocal spell spelllang=en
    setlocal noexpandtab
    setlocal wrap
    setlocal linebreak
    " Disable automatic newlines.
    setlocal textwidth=0 
    nnoremap j gj
    nnoremap k gk
    setlocal formatoptions=tcqnr21
    " setlocal formatprg=par
endfunction

" PEP8 Compliant, python config
function! PythonFiletypeConfig()
    setl tabstop=4
    setl softtabstop=4
    setl shiftwidth=4
    setl textwidth=79
    setl expandtab
    setl encoding=utf-8
    let python_highlight_all=1
    call ConfigureSimpylFold()
endfunction

function! CUEFIFiletypeConfig()
endfunction

function! CLinuxFiletypeConfig()
    setl tabstop=8
    setl softtabstop=8
    setl shiftwidth=8
    setl textwidth=79
    setl noexpandtab
endfunction

function! GolangFiletypeConfig()
    setl tabstop=8 
    setl softtabstop=8 
    setl shiftwidth=8 
    setl noexpandtab
endfunction

function! BashFiletypeConfig()
    setl tabstop=4 
    setl softtabstop=4 
    setl shiftwidth=4 
    setl textwidth=0
    setl noexpandtab
endfunction

function! VimFiletypeConfig()
    setl foldmethod=marker
    setl tabstop=4 
    setl softtabstop=4 
    setl shiftwidth=4 
endfunction

""""""""""""""""""""""""""""""""""""
""""    `Set Filetypes`		"{{{
""""""""""""""""""""""""""""""""""""
if has("autocmd")

    " Return to last edit position when opening files
    augroup Startup
        au!
        au BufReadPost * call ReturnToLastLocation()
        au BufNewFile,BufRead makefile.inc set filetype=make
        au BufNewFile,BufRead SConscript,SConstruct set filetype=python
    augroup END

    """"""""""""""""""""""""""""""""""""
    """"    `Markdown, Text`        "{{{
    """"""""""""""""""""""""""""""""""""
    augroup MarkdownText
        au!
        au Filetype markdown,text call PlainFilyetypeConfig()
        au FileType markdown setl expandtab
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `Makefile`          "{{{
    """"""""""""""""""""""""""""""""""""
    " On make files, don't use tab rules
    augroup Makefile
        au!
        au FileType make setl noexpandtab 
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `Python`            "{{{
    """"""""""""""""""""""""""""""""""""
    augroup Python
        au!
        au Filetype python call PythonFiletypeConfig()
        " autoremove trailing whitespace on save and preserve history
        au BufWritePre *.py call Preserve("%s/\\s\\+$//e")
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"            `Bash`          "{{{
    """"""""""""""""""""""""""""""""""""
    augroup Bash
        au!
        au FileType sh call BashFiletypeConfig()
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"            `C`             "{{{
    """"""""""""""""""""""""""""""""""""
    augroup C
        au!
        au FileType C call CLinuxFiletypeConfig()
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"            `VimL`	    "{{{
    """"""""""""""""""""""""""""""""""""
    augroup VimL
        au!
        au FileType vim call VimFiletypeConfig()
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `Golang`	    "{{{
    """"""""""""""""""""""""""""""""""""
    augroup Golang
        au!
        au Filetype go call GolangFiletypeConfig()
    augroup END

    " Source the vimrc file after saving it
    augroup Vimrc
        au!
        autocmd bufwritepost .vimrc source $MYVIMRC
    augroup END
endif
"}}} -------------------------------
"}}} ==============================================================
