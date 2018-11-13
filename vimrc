" Vi IMproved
set nocompatible

if !empty(glob("~/.vim/autoload/plug.vim"))

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Colorscheme "
"Plug 'morhetz/gruvbox'
"Plug 'jnurmine/Zenburn'
Plug 'joshdick/onedark.vim'
Plug 'chrisbra/csv.vim'
" Plug 'sjl/badwolf'

""""""""""""""""""""""""""""""""""""
""""    `IDE Plugs`           "{{{
""""""""""""""""""""""""""""""""""""
" Auto check syntax
Plug 'scrooloose/syntastic'
" PEP 8 checking, must have syntastic
Plug 'nvie/vim-flake8'
" Improve folding of functions.
Plug 'tmhedberg/SimpylFold'
" Autocompletion simplified.
" Go to github for install docs, otherwise will default install for python.
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
" Generates a YCM config file
"Plug 'rdnetto/YCM-Generator'
" Rust
" Plug 'rust-lang/rust.vim'
" Golang
Plug 'fatih/vim-go'

" Plug 'scrooloose/nerdtree'
" Plug 'vim-scripts/gtags.vim'
Plug 'spwilson2/cscope_maps'

" Useful if go to ctags, but doesn't work for global.
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-easytags'

" Display tags on the edge of the screen
"Plug 'majutsushi/tagbar'

" Fuzzy Finder for files and sources
" Plug 'kien/ctrlp.vim'

""""""""""""""""""""""""""""""""""""
""""    `Git Integration`       "{{{
""""""""""""""""""""""""""""""""""""
  " Most notable additions it brings:
  " :Gdiff bring up working diff with staged file
  " :Gstatus press - to add/reset p to add --interactive
"Plug 'tpope/vim-fugitive'

  " Most notable additions it brings:
  " ]c or [c go to next/prev hunk
  " <operator>ic perform action on current hunk
"Plug 'airblade/vim-gitgutter'
"}}} ------------------------------

""""""""""""""""""""""""""""""""""""
""""    `Text Wrangling`        "{{{
""""""""""""""""""""""""""""""""""""
" Helps with surrounding items in brackets/parthenesis etc.
Plug 'tpope/vim-surround'
"}}} -------------------------------


" Initialize plugin system
call plug#end()
else
	echom "Plugged can't be found"
endif
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `General Settings`      --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Space is leader key
let mapleader=" "
set timeoutlen=400

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

" Use a matching menu for selecting files.
set wildmenu

" Always use *nix line endings.
set fileformats=unix,dos

" Move vertically earlier
set so=7

" Disable automatic folding
set foldlevel=99

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar

set sessionoptions=curdir,folds,help,tabpages,winsize
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-----------    `Defualt Filetype Config`       --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set linebreak
set textwidth=0
set formatoptions=tcrqj1
set foldmethod=manual

""""""""""""""""""""""""
"""  => Indentation """"
""""""""""""""""""""""""
set shiftwidth=4   " Width for > and < cmds
set tabstop=8      " Visual length of tabs
set softtabstop=4  " Length to use spaces at instead of tabs
set expandtab      " Use spaces instead of tabs
set smarttab       " Tab to previous set lines
set autoindent     " Auto indent following lines
set cinoptions=(0  " Params in parenthesis are same indentation.

""""""""""""""""""""
"""  Searches   """"
""""""""""""""""""""
" When searching try to be smart about cases
set ignorecase
set smartcase
set incsearch
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

function! BufClose()
    sbprevious
    wprevious
    bdelete
endfunction

function! CleanUpWhitespace()
    call Preserve("%s/\\s\\+$//e")
endfunction

" Add cleanup on save to a buffer.
function! AddCleanupOnSave()
    augroup CleanupWhitespace
        au!
        au BufWritePre <buffer> call CleanUpWhitespace()
    augroup END
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

function! AutoAddGTags()
    let cmd = "cd " . expand('%:h') . " && global -pq"
    let l:CSCOPE_DB = system(cmd)[:-2]
    silent echo 'Automatically loaded tags file: ' . l:CSCOPE_DB . "/GTAGS"
    if l:CSCOPE_DB != ''
        execute 'cs add '. l:CSCOPE_DB . "/GTAGS"
    endif
endfunction

function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

function! ConfigureGtags()
    " add any GTAGS database in current directory
    if filereadable("GTAGS")
        cs add GTAGS
        set csprg=gtags-cscope
        set nocscopeverbose
        call AutoAddGTags()
    else
        call LoadCscope()
    endif
endfunction

function! ToggleSidebar()
    set invnumber
    "GitGutterToggle
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

function! OpenLog()
    let l:log = g:logdir . "/log.rst"
    execute '!~/projects/productivity/log.py' l:log
    execute 'tabe' l:log
endfunction

function! OpenNotes()
    let l:notes = g:logdir . "/notes.rst"
    execute 'tabe' l:notes
endfunction

function! InsertDateHeading()
    read !date +\%Y-\%m-\%d
endfunction

" Initialization which needs to take place a little time in the future so other
" plugins don't override.
function! PostInitSetup(timer)
    " Insert tab, YCM overrides the hotkey
    inoremap <S-Tab> <C-V><Tab>
endfunction

function! ReplaceTabs() range
    let l:spaces = &tabstop
    let l:count = 0
    let l:str = ''
    while l:count < l:spaces
        let l:str = l:str . ' '
        let l:count = 1 + l:count
    endwhile
    execute "'<,'>s/	/" . l:str . '/g'
endfunction
		

let _timer = timer_start(100, 'PostInitSetup', {})

let g:logdir = "~/Documents/logs"

command! -range ReplaceTabs call ReplaceTabs()
command! CleanWhitespace call CleanUpWhitespace()
command! Log call OpenLog()
command! Notes call OpenNotes()
command! AddDate call InsertDateHeading()

"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Hotkeys`       ----------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the toggle for pastemode to <F2>
set pastetoggle=<F2>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy
nnoremap Y y$

" Quick quit
nnoremap <C-Q> :bd<CR>
" Delete buffer without closing the window
nnoremap <C-X> :b#<bar>bd#<CR>

" Manually regen ctags
nnoremap <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Toggle highlight
noremap <silent> <Leader>l :setl invhls<cr><C-l>

" Toggle listchars
nnoremap <Leader>h :set invlist<CR>

" Toggle Spell Check.
nnoremap <Leader>sc :setl invspell<CR>


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

set display=lastline

" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag
" check cscope for definition of a symbol before checking ctags
set csto=0
" Set vim yanks to clipboard
set clipboard=unnamedplus

syntax enable   " Enable syntax highlighting

" Color setting
colorscheme onedark
"colorscheme badwolf
"colorscheme gruvbox
set background=dark
"colorscheme zenburn

" Set the color for listchars
hi SpecialKey guifg=red ctermfg=red
set listchars=tab:»·,trail:·
set list

""""""""""""""""""""""""""""""""""""
""""    `Status Line`           "{{{
""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
" Format the status line
set statusline=\ %{HasPaste()}%.30F%m%r%h\ %w\ \ %{SyntasticStatuslineFlag()}\ %=Buf:\ [%n]\ %l,%c
" Show the command in progress at bottom.
set showcmd
"}}} -------------------------------
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Plugin Configs`        --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""
""""    `vim-go`                "{{{
""""""""""""""""""""""""""""""""""""
let g:go_version_warning = 0
""""""""""""""""""""""""""""""""""""
""""    `Syntastic`             "{{{
""""""""""""""""""""""""""""""""""""
" if python 3 not working. Set the path.
"let g:syntastic_python_python_exec = '/usr/bin/python3'
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
" Show all errors, don't stop on first error checker.
let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"}}} -------------------------------

""""""""""""""""""""""""""""""""""""
""""    `YouCompleteMe`         "{{{
""""""""""""""""""""""""""""""""""""
" if python 3 not working. Set the path.
"let gycm_path_to_python_interpreter = '/usr/bin/python3'
"let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_conf.py'

" Disable to turn off asking about running files.
" let g:ycm_confirm_extra_conf = 1

"}}} ------------------------------

""""""""""""""""""""""""""""""""""""
""""    `Nerdtree`              "{{{
""""""""""""""""""""""""""""""""""""
" Tab to open nerdtree
"noremap <Tab> :NERDTreeToggle<CR>
"
" Close if nerdtree is last buffer open
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"}}} -------------------------------

""""""""""""""""""""""""""""""""""""
""""        `Ctrl P`            "{{{
""""""""""""""""""""""""""""""""""""
" Search through ctags with <,.>
" nnoremap <leader>c :CtrlPTag<cr>
let g:ctrlp_max_files=200000
"}}} ------------------------------

""""""""""""""""""""""""""""""""""""
""""        `Tagbar`            "{{{
""""""""""""""""""""""""""""""""""""
nmap <F3> :TagbarToggle<CR>
"}}} ------------------------------

""""""""""""""""""""""""""""""""""""
""""    `SimpylFold`            "{{{
""""""""""""""""""""""""""""""""""""
function! ConfigureSimpylFold()
    setl foldmethod=expr
endfunction
"}}} -------------------------------
""""""""""""""""""""""""""""""""""""
""""    `Gtags`                 "{{{
""""""""""""""""""""""""""""""""""""
"set csprg=gtags-cscope
"}}} -------------------------------
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Misc`       -------------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set whichwrap+=<,>",h,l
"Clear the background
set t_ut=
" Keep searching down until home or found tags.
set tags=./tags;$HOME,tags;

"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Filetypes`       --------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The general plain text file setup
function! PlainFiletypeConfig()
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
    setl tabstop=2
    setl softtabstop=2
    setl shiftwidth=2
    setl textwidth=0
    setl expandtab
endfunction

function! VimFiletypeConfig()
    setl foldmethod=marker
    setl tabstop=4
    setl softtabstop=4
    setl shiftwidth=4
endfunction

function! AdaFiletypeConfig()
    call LoadCscope()
endfunction

function! MakeFiletypeConfig()
endfunction
"""""""""""""""""""""""""""""""""
""""    `GHS Configuration`     "
"""""""""""""""""""""""""""""""""
function! GHS_C_FiletypeConfig()
    setl tabstop=8
    setl softtabstop=4
    setl shiftwidth=4
    setl textwidth=80
    setl linebreak
    setl cinoptions=(0,g.5s,h.5s
    setl expandtab
    setl formatoptions=crqnj12t
    " Format
    setl list
    setl listchars=tab:»·,trail:·
endfunction
function! GHS_PythonFiletypeConfig()
    setl tabstop=8
    setl softtabstop=4
    setl shiftwidth=4
    setl textwidth=80
    setl linebreak
    setl expandtab
    setl encoding=utf-8
    setl list
    setl listchars=tab:»·,trail:·
    let python_highlight_all=1
    call ConfigureSimpylFold()
endfunction

""""""""""""""""""""""""""""""""""""
""""    `Gem5 Configuration`       "
""""""""""""""""""""""""""""""""""""
function! Gem5CCFiletypeConfig()
    setl tabstop=4
    setl softtabstop=4
    setl shiftwidth=4
    setl textwidth=79
    setl linebreak
    setl cinoptions=(0,g.5s,h.5s
    setl expandtab
    setl formatoptions=crqnj12t
    " Highlight trailing spaces.
    setl list
    setl listchars=trail:\
    setl listchars=tab:»·,trail:·
endfunction
function! Gem5PythonFiletypeConfig()
    setl tabstop=4
    setl softtabstop=4
    setl shiftwidth=4
    setl textwidth=79
    setl linebreak
    setl expandtab
    setl cinoptions=(0,g.5s,h.5s
    setl formatoptions=crqnj12t
    " Highlight trailing spaces.
    setl list
    setl listchars=trail:\
endfunction

function! TryGem5FiletypeConfig(filetype)
    if matchstr(expand('%:p'), '*/gem5/*') == -1
        return
    elseif a:filetype == 'CC'
        call Gem5CCFiletypeConfig()
    elseif a:filetype == 'Python'
        call Gem5PythonFiletypeConfig()
    endif
endfunction

function! Gem5FiletypeOverrides()
    let l:ext = expand('%:e')
    if l:ext == "c" || l:ext == "hh" || l:ext == "cc"
    endif
endfunction

""""""""""""""""""""""""""""""""""""
""""    `Set Filetypes`		"{{{
""""""""""""""""""""""""""""""""""""
function! SetupDefaultFiletypes()
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
        au Filetype markdown,rst,text call PlainFiletypeConfig()
        au FileType markdown setl expandtab
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"    `Override Plaintext`    "{{{
    """"""""""""""""""""""""""""""""""""
    augroup PlaintextOverride
        au!
        au BufNewFile,BufRead *.dml call PlainFiletypeConfig()
    augroup END

    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `Makefile`          "{{{
    """"""""""""""""""""""""""""""""""""
    " On make files, don't use tab rules
    augroup Makefile
        au!
        au FileType make call MakeFiletypeConfig()
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `Python`            "{{{
    """"""""""""""""""""""""""""""""""""
    augroup Python
        au!
        au BufNewFile,BufRead SConstruct,SConscript set filetype=python
        au Filetype python call GHS_PythonFiletypeConfig()
        " Add automatic cleaning of whitespace to buffer saves.
        " au Filetype python call AddCleanupOnSave()
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
    """"            `CC`             "{{{
    """"""""""""""""""""""""""""""""""""
    augroup CC
        au!
        au FileType c,h,cpp call GHS_C_FiletypeConfig()

        " Automatically try and load gtags for these projects.
        au FileType c,h,cpp call ConfigureGtags()
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `Assembly`          "{{{
    """"""""""""""""""""""""""""""""""""
    augroup ASM
        au!
        au BufNewFile,BufRead *.a64, set filetype=asm
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
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `Ada`	            "{{{
    """"""""""""""""""""""""""""""""""""
    augroup Ada
        au!
        au Filetype ada call AdaFiletypeConfig()
    augroup END
    augroup DML
        au!
        au BufNewFile,BufRead *.dml, set filetype=text
    augroup END
    "}}} -------------------------------

    """"""""""""""""""""""""""""""""""""
    """"        `vimrc`	            "{{{
    """"""""""""""""""""""""""""""""""""
    " Source the vimrc file after saving it
    augroup Vimrc
        au!
        autocmd bufwritepost .vimrc source $MYVIMRC
        autocmd bufwritepost vimrc source $MYVIMRC
    augroup END
endfunction

" Set up all the autogroups.
call SetupDefaultFiletypes()
"}}} -------------------------------
"}}} ==============================================================
