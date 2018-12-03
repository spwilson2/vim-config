function! DefaultConfig()
    set fileformats=unix,dos

    set linebreak
    set textwidth=0
    set formatoptions=tcrqj1
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
        au FileType c,h,cpp exec ':setl colorcolumn=' . &textwidth
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
        au FileType c,h,cpp exec ':setl colorcolumn=' . &textwidth
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
        autocmd bufwritepost vimrc call LightlineReload()
    augroup END
endfunction

call DefaultConfig()
call SetupDefaultFiletypes()
