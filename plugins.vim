"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Post Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! plugins#airline()
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts = 1
    set noshowmode
    set laststatus=2
    set showcmd " Show the chord in progress
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    " unicode symbols
    let g:airline_left_sep = '»'
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '«'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '␊'
    let g:airline_symbols.linenr = '␤'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.paste = '∥'
    let g:airline_symbols.whitespace = 'Ξ'
endfunction " airline

function! plugins#fzf()
    nnoremap <silent> <Leader>b :Buffers<CR>
    nnoremap <silent> <Leader>f :Files<CR>
endfunction

function! plugins#coc()

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " GoTo code navigation.
    nmap <leader>gd <Plug>(coc-definition)
    nmap <leader>gy <Plug>(coc-type-definition)
    nmap <leader>gi <Plug>(coc-implementation)
    nmap <leader>gr <Plug>(coc-references)
    nmap <leader>rr <Plug>(coc-rename)
    nmap <leader>g[ <Plug>(coc-diagnostic-prev)
    nmap <leader>g] <Plug>(coc-diagnostic-next)

    let g:coc_disable_startup_warning = 1
endfunction

function! plugins#gruvbox()
    let g:gruvbox_guisp_fallback = "bg"
    " Set the background color for gitgutter
    let g:gruvbox_sign_column = 'bg0'
    set background=dark
    colorscheme gruvbox
endfunction

function! plugins#gruvboxlight()
    call plugins#gruvbox()
    set background=light
endfunction

function! plugins#youcompleteme()
    " if python 3 not working. Set the path.
    let gycm_path_to_python_interpreter = '/usr/bin/python3'
    let g:ycm_show_diagnostics_ui = 1
    let g:ycm_enable_diagnostic_signs = 0
    let g:ycm_enable_diagnostic_highlighting = 0

    nnoremap <silent> <Leader>gd :YcmCompleter GoToDefinition<CR>
    nnoremap <silent> <Leader>gr :YcmCompleter GoToReferences<CR>
    "let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_conf.py'
    " Disable to turn off asking about running files.
    " let g:ycm_confirm_extra_conf = 1
endfunction

function! plugins#ale()
    let g:ale_linters_explicit = 1
    let g:ale_linters = {
                \ 'python': ['pycodestyle'],
                \ 'rust': ['cargo'],
                \ }
    let g:ale_rust_rls_toolchain = 'nightly'
    let g:ale_set_balloons = 1
    let g:ale_enabled = 1
endfunction

if !empty(glob("~/.vim/autoload/plug.vim"))

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Plugin Selection
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    exec 'source ' . expand("~/.vim/local/myplug.vim")
    call myplug#begin('~/.vim/plugged')


    MyPlug 'gruvbox-community/gruvbox', {'configure': function('plugins#gruvbox')}
    "MyPlug 'gruvbox-community/gruvbox', {'configure': function('plugins#gruvboxlight')}

    " Improved status line
    MyPlug 'vim-airline/vim-airline', {'configure' : function('plugins#airline')}

    " Plugin for UNIX commands in command mode.
    MyPlug 'tpope/vim-eunuch'

    " Async Linting
    "MyPlug 'w0rp/ale', {'configure': function('plugins#ale')}
    
    " Improved Autocompletion
    "MyPlug 'Valloric/YouCompleteMe', {
    "            \ 'do': 'python3 ./install.py --go-completer --rust-completer --ts-completer',
    "            \ 'configure': function('plugins#youcompleteme')}
    "Plug 'rdnetto/YCM-Generator'

    "Extensions https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
    MyPlug 'neoclide/coc.nvim', {'branch': 'release',
                            \ 'configure': function('plugins#coc')}

    " Fuzzy-find search of whatever (Tabs Buffers Files)
    MyPlug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' ,
                            \ 'configure': function('plugins#fzf')}
    MyPlug 'junegunn/fzf.vim'

    MyPlug 'spwilson2/cscope_maps'

    MyPlug 'mbbill/undotree'

    " Useful surround movements/edits
    MyPlug 'tpope/vim-surround'
    " g= is a cool eval shortcut always keeping on.
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
    " Language pack to outperform default syntax settings
    MyPlug 'sheerun/vim-polyglot'

    " Adds RustFmt
    "MyPlug 'rust-lang/rust.vim', { 'for': 'rust'}
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
