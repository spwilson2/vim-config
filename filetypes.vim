function! DefaultConfig()
    set fileformats=unix,dos

    set linebreak
    set textwidth=0
    set formatoptions=crqj1
    set foldmethod=manual

    " Indentation
    set shiftwidth=4   " Width for > and < cmds
    set tabstop=8      " Visual length of tabs
    set softtabstop=4  " Length to use spaces at instead of tabs
    set expandtab      " Use spaces instead of tabs
    set smarttab       " Tab to previous set lines
    set autoindent     " Auto indent following lines
    set cinoptions=(0  " Params in parenthesis are same indentation.
endfunction

function! RustFiletypeConfig()
    nmap gd <Plug>(rust-def)
    nmap gs <Plug>(rust-def-split)
    nmap gx <Plug>(rust-def-vertical)
    nmap <leader>gd <Plug>(rust-doc)

    setl tabstop=2
    setl softtabstop=2
    setl shiftwidth=2
    setl expandtab
    setl textwidth=79
    setl linebreak
    "setl cinoptions=(0,g.5s,h.5s
    setl formatoptions=crqnj12
    " Format
    setl list
    setl listchars=tab:»·,trail:·
endfunction

" The general plain text file setup
function! PlainFiletypeConfig()
    setlocal spell spelllang=en
    setlocal expandtab
    setlocal wrap
    setlocal linebreak
    " Disable automatic newlines.
    setlocal textwidth=0
    nnoremap j gj
    nnoremap k gk
    setlocal formatoptions=cqnr21
    " setlocal formatprg=par
endfunction

" PEP8 Compliant, python config
function! PythonFiletypeConfig()
    setl tabstop=4
    setl softtabstop=4
    setl shiftwidth=4
    setl textwidth=79
    setl expandtab
endfunction

function! Javascript_FiletypeConfig()
    setl tabstop=2
    setl shiftwidth=2
    setl softtabstop=2
    setl textwidth=100
    setl expandtab
endfunction

function! Linux_C_FiletypeConfig()
    setl tabstop=8
    setl shiftwidth=8
    setl softtabstop=8
    setl textwidth=80
    setl noexpandtab
    setl cindent
	setl cinoptions=:0,l1,t0,g0,(0
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
    setl cinoptions=
    setl noexpandtab
    setl formatoptions=crqnj12t
    " Format
    setl list
    setl listchars=tab:»·,trail:·
endfunction

function! GHS_PythonFiletypeConfig()
    setl tabstop=8
    setl softtabstop=4
    setl shiftwidth=4
    setl textwidth=79
    setl linebreak
    setl expandtab
    setl list
    setl listchars=tab:»·,trail:·
    let b:python_highlight_all=1
endfunction

function! Try_C_FiletypeConfigs()
    "if (matchstr(expand('%:p'), '*/linux/*') == 0)
    "    call Linux_C_FiletypeConfig()
    "else
        call GHS_C_FiletypeConfig()
    "endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autogroup commands for each filetype
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Declare in a function so their order is placed after and final preconfiguration
function! SetupDefaultFiletypes()
augroup Generic
	au!
	au BufNewFile,BufRead makefile.inc set filetype=make
	au BufNewFile,BufRead SConscript,SConstruct set filetype=python
augroup END

augroup Text
	au!
	au Filetype markdown,rst,text call PlainFiletypeConfig()
	au FileType markdown setl expandtab
augroup END

augroup DML
	au!
	au BufNewFile,BufRead *.dml, set filetype=text
	au BufNewFile,BufRead *.dml call PlainFiletypeConfig()
augroup END

augroup DTB
    au!
    function! DtbLoad()
        let l:tmpfile = tempname() . '.dtb'
        execute 'write ' . l:tmpfile
        1,$d
        execute 'read !fdtdump  ' . l:tmpfile
        execute 'silent !rm ' . l:tmpfile
    endfunction
    function! DtbSave()
        let l:tmpfile = tempname() . '.dts'
        execute 'write ' . l:tmpfile
        " TODO Need to support different dtc paths...
        execute '!dtc -O dtb -o ' . expand('%') . ' ' . l:tmpfile 
    endfunction
    au BufReadPost *.dtb call DtbLoad() | set ro
    au BufReadPost *.dtb set filetype=dts
    "au BufWritePre *.dtb call DtbSave() | call DtbLoad() | set nomod
augroup END

augroup Makefile
	au!
	au FileType make call MakeFiletypeConfig()
augroup END

augroup Python
	au!
	au BufNewFile,BufRead SConstruct,SConscript set filetype=python
	au Filetype python call GHS_PythonFiletypeConfig()
	" Add automatic cleaning of whitespace to buffer saves.
	" au Filetype python call AddCleanupOnSave()
augroup END

augroup Bash
	au!
	au FileType sh call BashFiletypeConfig()
augroup END

augroup CC
	au!
	au FileType c,h,cpp call Try_C_FiletypeConfigs()
	au FileType c,h,cpp call ConfigureGtags()
augroup END

augroup ASM
	au!
	au BufNewFile,BufRead *.a64, set filetype=asm
augroup END

augroup VimL
	au!
	au FileType vim call VimFiletypeConfig()
augroup END

augroup Golang
	au!
	au Filetype go call GolangFiletypeConfig()
augroup END

augroup Ada
	au!
	au Filetype ada call AdaFiletypeConfig()
augroup END

augroup DML
	au!
augroup END

augroup JS
	au!
	au Filetype javascript,css,scss,typescriptreact call Javascript_FiletypeConfig()
augroup END

augroup Vimrc
	au!
	au bufwritepost .vimrc source $MYVIMRC
	au bufwritepost vimrc source $MYVIMRC
	au bufwritepost vimrc call LightlineReload()
augroup END

augroup Rust
	au!
	au FileType rust call RustFiletypeConfig()
augroup END
endfunction

" Make sure default is first so it is executed before non-default filetype
call DefaultConfig()
call SetupDefaultFiletypes()
