let g:logdir = "~/Documents/logs"

function! OpenLog()
    let l:log = g:logdir . "/log.rst"
    execute '!~/projects/productivity/log.py' l:log
    execute 'tabe' l:log
endfunction

function! OpenNotes()
    let l:notes = g:logdir . "/notes.rst"
    execute 'tabe' l:notes
endfunction

function! InsertDateHeading()
    read !date +\%Y-\%m-\%d
endfunction

command! Log call OpenLog()
command! Notes call OpenNotes()
command! AddDate call InsertDateHeading()
