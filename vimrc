" Vi IMproved
set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"---------------------     `Vundle`   ------------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" Find more plugins here
" http://vimawesome.com/

""""""""""""""""""""""""""""""""""""
""""    `Vundle Init`           "{{{
""""""""""""""""""""""""""""""""""""
if !empty(glob("~/.vim/bundle/Vundle.vim"))
	filetype off                  " required

	" set the runtime path to include Vundle and initialize
	set runtimepath+=~/.vim/bundle/Vundle.vim
	call vundle#begin()

	" alternatively, pass a path where Vundle should install plugins
	" call vundle#begin('~/some/path/here')
	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'
	"}}} ------------------------------

	""""""""""""""""""""""""""""""""""""
	""""    `Colorschemes`          "{{{
	""""""""""""""""""""""""""""""""""""
	" GUI
	" Plugin 'altercation/vim-colors-solarized'
	" Plugin 'sandeepsinghmails/Dev_Delight'

	" XTERM
	" Plugin 'jnurmine/Zenburn'
	" Plugin 'NLKNguyen/papercolor-theme'
    " Plugin 'sjl/badwolf'
    Plugin 'morhetz/gruvbox'

	" Need to change colors to work well
	" Plugin 'joshdick/onedark.vim'
	"}}} ------------------------------

	""""""""""""""""""""""""""""""""""""
	""""    `IDE Plugins`           "{{{
	""""""""""""""""""""""""""""""""""""
	" Auto check syntax
	Plugin 'scrooloose/syntastic'

	" PEP 8 checking, must have syntastic
	Plugin 'nvie/vim-flake8'

	" Improve folding of functions.
	Plugin 'tmhedberg/SimpylFold'

	" Autocompletion. Go to github for install docs.
	Plugin 'Valloric/YouCompleteMe'

    " Generates a YCM config file
    Plugin 'rdnetto/YCM-Generator'

	" Robot python syntax
	" Plugin 'mfukar/robotframework-vim'
    " Plugin 'rust-lang/rust.vim'
	" golang syntax
	Plugin 'fatih/vim-go'

	" Plugin 'scrooloose/nerdtree'
    Plugin 'vim-scripts/gtags.vim'
    Plugin 'spwilson2/cscope_maps'

    " Useful if go to ctags, but doesn't work for global.
	" Plugin 'xolox/vim-misc'
	" Plugin 'xolox/vim-easytags'

    Plugin 'majutsushi/tagbar'

	"}}} ------------------------------

	""""""""""""""""""""""""""""""""""""
	""""    `Git Integration`       "{{{
	""""""""""""""""""""""""""""""""""""
    " Most notable additions it brings:
    " :Gdiff bring up working diff with staged file
    " :Gstatus press - to add/reset p to add --interactive
	Plugin 'tpope/vim-fugitive'

    " Most notable additions it brings:
    " ]c or [c go to next/prev hunk
    " <operator>ic perform action on current hunk
	Plugin 'airblade/vim-gitgutter'
	"}}} ------------------------------

	""""""""""""""""""""""""""""""""""""
	""""    `Text Wrangling`        "{{{
	""""""""""""""""""""""""""""""""""""
	" Helps with surrounding items in brackets/parthenesis etc.
    Plugin 'tpope/vim-surround'
	"}}} -------------------------------

	call vundle#end()
else
	echom "Vundle can't be found"
endif
filetype plugin indent on
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
    set csprg=gtags-cscope
    set nocscopeverbose  
    " add any GTAGS database in current directory
    if filereadable("GTAGS")
        cs add GTAGS
    else
        call AutoAddGTags()
    endif
endfunction

" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag
" check cscope for definition of a symbol before checking ctags
set csto=0

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
"colorscheme onedark
"colorscheme badwolf
"
colorscheme gruvbox
set background=dark

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Plugin Configs`        --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""
""""    `Syntastic`             "{{{
""""""""""""""""""""""""""""""""""""
" if python 3 not working. Set the path.
let g:syntastic_python_python_exec = '/usr/bin/python3'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"}}} -------------------------------

""""""""""""""""""""""""""""""""""""
""""    `YouCompleteMe`         "{{{
""""""""""""""""""""""""""""""""""""
" if python 3 not working. Set the path.
let gycm_path_to_python_interpreter = '/usr/bin/python3'
"let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_conf.py'

" Disable to turn off asking about running files.
let g:ycm_confirm_extra_conf = 1

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

function! AdaFiletypeConfig()
    call LoadCscope()
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
        au BufNewFile,BufRead SConstruct,SConscript set filetype=python
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
        au FileType c,h,cpp call CLinuxFiletypeConfig()
        " au FileType c,h,cpp call CUEFIFiletypeConfig()
        " autoremove trailing whitespace on save and preserve history
        au BufWritePre *.c,h,cpp call Preserve("%s/\\s\\+$//e")
        setl formatoptions+=t

        " Automatically try and load gtags for these projects.
        au FileType c,h,cpp call ConfigureGtags()
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
    "}}} -------------------------------

    " Source the vimrc file after saving it
    augroup Vimrc
        au!
        autocmd bufwritepost .vimrc source $MYVIMRC
    augroup END
endif
"}}} -------------------------------
"}}} ==============================================================
