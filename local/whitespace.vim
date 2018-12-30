" Preserves the previous state after running a command
" Add cleanup on save to a buffer.
function! AddCleanupOnSave()
    augroup CleanupWhitespace
        au!
        au BufWritePre <buffer> CleanWhitespace
    augroup END
endfunction

command! -range=%  CleanWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``

function! s:replacetabs()
    let l:spaces = &tabstop
    let l:count = 0
    let l:str = ''
    while l:count < l:spaces
        let l:str = l:str . ' '
        let l:count = 1 + l:count
    endwhile
    execute "'<,'>s/	/" . l:str . '/ge'
endfunction

command! -range=% ReplaceTabs <line1>,<line2>call s:replacetabs()
