" Preserves the previous state after running a command
function! s:preserve(command)
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

function! CleanUpWhitespace()
    call s:preserve("%s/\\s\\+$//e")
endfunction

" Add cleanup on save to a buffer.
function! AddCleanupOnSave()
    augroup CleanupWhitespace
        au!
        au BufWritePre <buffer> call CleanUpWhitespace()
    augroup END
endfunction

command! CleanWhitespace call CleanUpWhitespace()

" Remove trailing whitespace and preserve the previous search pattern
" nnoremap _$ :call Preserve("%s/\\s\\+$//e")<CR>

function! s:replacetabs() range
    let l:spaces = &tabstop
    let l:count = 0
    let l:str = ''
    while l:count < l:spaces
        let l:str = l:str . ' '
        let l:count = 1 + l:count
    endwhile
    execute "'<,'>s/	/" . l:str . '/g'
endfunction

command! -range ReplaceTabs call s:replacetabs()
