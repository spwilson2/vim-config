"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Post Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! plugins#lightline()
    set laststatus=2
    set noshowmode
    if !has('gui_running')
      set t_Co=256
    endif

    "let g:lightline = {
    "      \ 'component_function': {
    "      \   'readonly': 'LightlineReadonly',
    "      \ },
    "      \ }
    "function! LightlineReadonly()
    "  return &readonly && &filetype !=# 'help' ? 'RO' : ''
    "endfunction

endfunction
"function! plugins#airline()
"    let g:airline#extensions#tabline#enabled = 1
"    let g:airline_powerline_fonts = 1
"    set noshowmode
"    set laststatus=2
"    set showcmd " Show the chord in progress
"    if !exists('g:airline_symbols')
"        let g:airline_symbols = {}
"    endif
"    " unicode symbols
"    let g:airline_left_sep = '»'
"    let g:airline_left_sep = '▶'
"    let g:airline_right_sep = '«'
"    let g:airline_right_sep = '◀'
"    let g:airline_symbols.linenr = '␊'
"    let g:airline_symbols.linenr = '␤'
"    let g:airline_symbols.linenr = '¶'
"    let g:airline_symbols.branch = '⎇'
"    let g:airline_symbols.paste = 'ρ'
"    let g:airline_symbols.paste = 'Þ'
"    let g:airline_symbols.paste = '∥'
"    let g:airline_symbols.whitespace = 'Ξ'
"endfunction " airline

function! plugins#fzf()
    nnoremap <silent> <Leader>b :Buffers<CR>
    nnoremap <silent> <Leader>f :Files<CR>
    nnoremap <silent> <Leader><Enter>  :Buffers<CR>
    nnoremap <silent> <Leader>L        :Lines<CR>
    nnoremap <silent> <Leader>/        :Rg<CR>
    xnoremap <silent> <Leader>/        y:Rg <C-R>"<CR>
    nnoremap <silent> <Leader>"        :Rg <C-R>"<CR>
    nnoremap <silent> <Leader>`        :Marks<CR>
endfunction

function! plugins#coc()

    
    " TextEdit might fail if hidden is not set.
    set hidden
    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c

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

  function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'h' expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  let g:coc_global_extensions = ['coc-git', 'coc-solargraph',
    \ 'coc-rust-analyzer', 'coc-python', 'coc-html', 'coc-json', 'coc-css', 'coc-html',
    \ 'coc-prettier', 'coc-eslint', 'coc-tsserver', 'coc-emoji'] " , 'coc-java']
  command! -nargs=0 Prettier :CocCommand prettier.formatFile


    function! s:configure_coc_mappings()
        " coc-git hotkeys
        " show commit contains current position
        nmap <silent> gc <Plug>(coc-git-commit)
        " navigate chunks of current buffer
        nmap <silent> [g <Plug>(coc-git-prevchunk)
        nmap <silent> ]g <Plug>(coc-git-nextchunk)
        " show chunk diff at current position
        nmap <silent> gs <Plug>(coc-git-chunkinfo)

        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
        nmap <silent> rr <Plug>(coc-rename)
    endfunction

    augroup coc-config
      autocmd!
      autocmd VimEnter * call <SID>configure_coc_mappings()
    augroup END

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

function! plugins#ycmbuild(info)
    !python3 ./install.py --go-completer --ts-completer
    !curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer
    !chmod +x ~/.local/bin/rust-analyzer
endfunction

function! plugins#youcompleteme()
    " if python 3 not working. Set the path.
    let gycm_path_to_python_interpreter = '/usr/bin/python3'
    let g:ycm_show_diagnostics_ui = 1
    let g:ycm_enable_diagnostic_signs = 0
    let g:ycm_enable_diagnostic_highlighting = 0
    let g:ycm_auto_hover = ""
    let g:ycm_always_populate_location_list = 1

    nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
    nnoremap <leader>d <plug>(YCMHover)
    nnoremap <silent> <leader>gr :YcmCompleter GoToReferences<CR>

    augroup RustYcm
        au!
        au FileType rust let g:ycm_enable_diagnostic_signs = 1
    augroup END

    let g:ycm_language_server =
      \ [
      \   {
      \     'name': 'rust',
      \     'filetypes': [ 'rust' ],
      \     'cmdline': [ 'rust-analyzer-linux' ],
      \     'project_root_files': [ 'Cargo.toml' ]
      \   }
      \ ]

    "let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_conf.py'
    " Disable to turn off asking about running files.
    " let g:ycm_confirm_extra_conf = 1
endfunction

function! plugins#nerdtree()
    nnoremap <leader>n :NERDTreeToggle<cr>
    nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
      augroup nerd_loader
        autocmd!
        autocmd VimEnter * silent! autocmd! FileExplorer
        autocmd BufEnter,BufNew *
              \  if isdirectory(expand('<amatch>'))
              \|   call plug#load('nerdtree')
              \|   execute 'autocmd! nerd_loader'
              \| endif
      augroup END
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
    MyPlug 'itchyny/lightline.vim', {'configure' : function('plugins#lightline')}

    " Plugin for UNIX commands in command mode.
    MyPlug 'tpope/vim-eunuch'
    MyPlug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle', 'configure': function('plugins#nerdtree')}

    " Async Linting
    "MyPlug 'w0rp/ale', {'configure': function('plugins#ale')}

    " Improved Autocompletion
    "MyPlug 'Valloric/YouCompleteMe', {
    "            \ 'do': function('plugins#ycmbuild'),
    "            \ 'configure': function('plugins#youcompleteme')}
    "Plug 'rdnetto/YCM-Generator'
    let g:fzf_action = {
      \ 'return': 'tabe',}

    MyPlug 'neoclide/coc.nvim', {'branch': 'release', 'configure': function('plugins#coc')}

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
    "MyPlug 'airblade/vim-gitgutter'
    " Svn Plugin
    MyPlug 'juneedahamed/svnj.vim'
    " Language pack to outperform default syntax settings
    "MyPlug 'sheerun/vim-polyglot'

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
