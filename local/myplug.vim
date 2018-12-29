function! s:Callback()
endfunction

function! s:Configure()
endfunction

let s:callbacks = []

function! myplug#begin(...)
    call call(function("plug#begin"), a:000)
endfunction

function! myplug#(...)
    " First argument is the source
    " Second argument is a dictionary for plug 
    " Pop from the dictionary 'configure'
    " If arg:0
    let l:dict = get(a:, 2, {})
    let l:CB = get(l:dict, 'configure', function("s:Callback"))
    if (get(l:dict, 'configure', '') != '')
        call remove(l:dict, 'configure')
    endif
    call add(s:callbacks, l:CB)
    call call(function("plug#"), a:000)
endfunction

function! myplug#end()
    call plug#end()
    for Cb in s:callbacks
        call Cb()
    endfor
endfunction

command! -nargs=+ -bar MyPlug call myplug#(<args>)
