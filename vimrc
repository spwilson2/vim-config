
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
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
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

" Need to change colors to work well
Plugin 'joshdick/onedark.vim'
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

" Robot python syntax
Plugin 'mfukar/robotframework-vim'

" golang syntax
Plugin 'fatih/vim-go'
"}}} ------------------------------

""""""""""""""""""""""""""""""""""""
""""    `Git Integration`       "{{{
""""""""""""""""""""""""""""""""""""
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
"}}} ------------------------------

""""""""""""""""""""""""""""""""""""
""""    `Text Wrangling`        "{{{
""""""""""""""""""""""""""""""""""""
" Helps with surrounding items in brackets/parthenesis etc.
" Plugin 'tpope/vim-surround'
"}}} -------------------------------

""""""""""""""""""""""""""""""""""""
""""    `Text Wrangling`        "{{{
""""""""""""""""""""""""""""""""""""
" Ctrlp to search
" Plugin 'kien/ctrlp.vim'
" Plugin 'scrooloose/nerdtree'
"}}} -------------------------------

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"}}} ==============================================================
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `General Settings`      --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Space is leader key
set mapleader=" "

" Turn backup off
set nobackup
set nowritebackup
set noswapfile

" Set the number of undos
set history=100

" Let vim go past the last char.
set virtualedit=onemore

" Configure backspace to remove endlines and indents
set backspace=eol,start,indent

" Allow traveling between buffers without the error prompt (liberally hides buffers)
set hidden

" Disable vim modeline reading (for security).
set modeline
set modelines=5

" Always use *nix line endings.
set fileformat=unix

" Show the command in progress at bottom.
set showcmd
"}}}
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-----------    `Defualt Filetype Config`       --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Linebreak on 99 characters
set linebreak
set textwidth=80
set formatoptions=tcrqj1

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

" Highlight search results
" set hls

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
if has('gui_running')
    "set background=dark
    "colorscheme solarized
    "colorscheme Dev_Delight
    "colorscheme onedark
    "set background=light
else

    "set background=dark
    colorscheme onedark
    "colorscheme PaperColor
endif

" No annoying sound on errors
set noerrorbells
set novisualbell

" Move vertically earlier
set so=7

"" Add a bit extra margin to the left
"set foldcolumn=1

"" Set color of the line numbers
":highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
"}}} ==============================================================


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Status`       ------------------------ {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%.30F%m%r%h\ %w\ \ cwd:\ %{getcwd()}\ \ \ %=Buf:\ [%n]\ %l,%c
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    en
    return ''
endfunction
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Plugin Configs`        --------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""
"""   syntastic         {{{
"""""""""""""""""""""""""""
" if python 3 not working. Set the path.
let g:syntastic_python_python_exec = '/usr/bin/python3'
" }}} ---------------------

"""""""""""""""""""""""""""
"""   YouCompleteMe     {{{
"""""""""""""""""""""""""""
" if python 3 not working. Set the path.
let gycm_path_to_python_interpreter = '/usr/bin/python3'
" }}} ---------------------

"""""""""""""""""""""""""""
"""   nerdtree          {{{
"""""""""""""""""""""""""""
" Tab to open nerdtree
" map <Tab> :NERDTreeToggle<CR>

" Close if nerdtree is last buffer open
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}} ---------------------

"""""""""""""""""""""""""""
"""   ctrlp             {{{
"""""""""""""""""""""""""""
" Search through ctags with <,.>
" nnoremap <leader>c :CtrlPTag<cr>
" }}} ---------------------

"""""""""""""""""""""""""""
"""   SimpylFold        {{{
"""""""""""""""""""""""""""
set foldlevel=99      " Need to disable automatic folding by SimpylFold
set foldmethod=syntax " Disable automatic folding
if has("autocmd")
    au FileType python set foldmethod=indent 
endif
" }}} ---------------------
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Misc`       -------------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set whichwrap+=<,>",h,l
set t_ut=

function! PlainText()
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
"}}} ==============================================================

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------     `Filetypes`       --------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")
    """""         All            """"""
    " Return to last edit position when opening files
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                \ exe "normal! g`\"" |
                \ endif

    """""        Markdown,Text    """"""
    "au BufNew,BufRead *.md setl =markdown
    au Filetype markdown,text call PlainText()
    au FileType markdown setl expandtab

    """""         Make            """"""
    au FileType make setl noexpandtab "On make files, don't use tab rules

    """""         Python          """"""
    " PEP8 Compliant ;)
    au BufNewFile,BufRead *.py setl tabstop=4|
                \setl softtabstop=4|
                \setl shiftwidth=4|
                \setl textwidth=79|
                \setl expandtab|
                \setl encoding=utf-8|
                \let python_highlight_all=1

    " auto remove trailing whitespace on save
    au BufWritePre *.py :call Preserve("%s/\\s\\+$//e")

    " Don't linebreak in shell scripts.
    au FileType sh :call PlainText() | set nospell


    """""           C             """"""
    au FileType C, setl tabstop=8 |
    setl softtabstop=8 |
    setl shiftwidth=8 |
    setl noexpandtab


    " Source the vimrc file after saving it
    " autocmd bufwritepost .vimrc source $MYVIMRC
    au BufNewFile,BufEnter go setl tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

endif
"}}} ==============================================================
"vim:set foldmethod=marker
