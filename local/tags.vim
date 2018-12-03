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

" Keep searching down until home or found tags.
set tags=./tags;$HOME,tags;
