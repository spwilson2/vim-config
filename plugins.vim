"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Post Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! plugins#lightline()
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
endfunction " lightline

function! plugins#peaksea()
    colorscheme peaksea
    set background=dark
endfunction

function! plugins#onedark()
    colorscheme onedark
    set background=dark
endfunction

function! plugins#papercolor()
    colorscheme PaperColor
    set background=light
endfunction

function! plugins#youcompleteme()
    " if python 3 not working. Set the path.
    let gycm_path_to_python_interpreter = '/usr/bin/python3'
    let g:ycm_show_diagnostics_ui = 1
    let g:ycm_enable_diagnostic_signs = 0
    let g:ycm_enable_diagnostic_highlighting = 0
    "let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_conf.py'
    " Disable to turn off asking about running files.
    " let g:ycm_confirm_extra_conf = 1
endfunction

function! plugins#nerdtree()
    " Tab to open nerdtree
    nnoremap <S-Tab> :NERDTreeToggle<CR>
    " Close if nerdtree is last buffer open
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endfunction

function! plugins#ctrlp()
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

function! plugins#vimgo()
    let g:go_version_warning = 0
endfunction

function! plugins#ale()
    let g:ale_linters_explicit = 1
    let g:ale_linters = {
                \ 'python': ['pycodestyle'],
                \ 'rust': ['cargo'],
                \ }
    let g:ale_rust_rls_toolchain = 'stable'
    let g:ale_set_balloons = 1
    let g:ale_enabled = 1
endfunction

if !empty(glob("~/.vim/autoload/plug.vim"))

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Plugin Selection
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    exec 'source ' . expand("~/.vim/local/myplug.vim")
    call myplug#begin('~/.vim/plugged')

    MyPlug 'joshdick/onedark.vim', {'configure': function('plugins#onedark')}
    "MyPlug 'NLKNguyen/papercolor-theme', {'configure': function('plugins#papercolor')}
    "MyPlug 'vim-scripts/peaksea', {'configure': function('plugins#peaksea')}

    MyPlug 'itchyny/lightline.vim', {'configure': function('plugins#lightline')}

    MyPlug 'scrooloose/nerdtree', {'configure': function('plugins#nerdtree')}
    MyPlug 'tpope/vim-eunuch'

    " Async Linting
    MyPlug 'w0rp/ale', {'configure': function('plugins#ale')}
    MyPlug 'Valloric/YouCompleteMe', {
                \ 'do': 'python3 ./install.py --go-completer --rust-completer --ts-completer',
                \ 'configure': function('plugins#youcompleteme')}
    "Plug 'rdnetto/YCM-Generator'

    MyPlug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    MyPlug 'junegunn/fzf.vim'

    " Useful if go to ctags, but doesn't work for global.
    "Plug 'xolox/vim-misc'
    "Plug 'xolox/vim-easytags'
    "Plug 'majutsushi/tagbar'
    MyPlug 'spwilson2/cscope_maps'

    MyPlug 'MattesGroeger/vim-bookmarks'
    MyPlug 'tpope/vim-surround'

    MyPlug 'tpope/vim-commentary'
    MyPlug 'tpope/vim-scriptease'

    " Manage vim sessions (layouts, persist state)
    "
    " Use :Obsess (with optional file/directory name) to start recording to
    " a session file and :Obsess! to stop and throw it away.
    "
    " Load a session in the usual manner: vim -S, or :source it.
    MyPlug 'tpope/vim-obsession'

    " Git Plugins
    MyPlug 'tpope/vim-fugitive'
    MyPlug 'airblade/vim-gitgutter'

    " Svn Plugin
    MyPlug 'juneedahamed/svnj.vim'

    MyPlug 'rust-lang/rust.vim', { 'for': 'rust'}
    MyPlug 'racer-rust/vim-racer', { 'for': 'rust'}
    MyPlug 'fatih/vim-go', { 'for': 'go', 'configure': function('plugins#vimgo')}
    " MyPlug 'chrisbra/csv.vim', { 'for': 'csv'}

    MyPlug 'leafgarland/typescript-vim', { 'for': ['typescript', 'javascript']}
    MyPlug 'Quramy/tsuquyomi', { 'for': ['typescript', 'javascript']}
    call myplug#end()
else
    echom "Plugged can't be found"
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec 'source ' . expand("~/.vim/local/whitespace.vim")
exec 'source ' . expand("~/.vim/local/tags.vim")
exec 'source ' . expand("~/.vim/local/log.vim")

if has("gui_running")
    exec 'source ' . expand("~/.vim/local/zoom.vim")
    nmap - :call FontSizeMinus()<CR>
    nmap + :call FontSizePlus()<CR>
endif
