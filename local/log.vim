let g:notedir = "~/.local/notes"
let g:logdir = "~/.local/notes/logs"

function! s:lazy_load()
pythonx << EOF
import datetime
import os
import re
import vim

now = datetime.datetime.now()
DATE = '%04d-%02d-%02d' % (now.year, now.month, now.day)

logdir = vim.eval('g:logdir')
logfile = os.path.join(logdir, '%s_log.rst' % DATE)
notedir = vim.eval('g:notedir')

def wrap(c, text, front=True, back=True):
    l = len(text)
    wrap = c * l

    if front:
        text = wrap + '\n' + text
    if back:
        text = text + '\n' + wrap
    return text

def header(date):
    cmt = wrap('.', "<| Programmer's Log - Earth Date: %s |>" % date)
    cmt = ['.. ' + l + ' ..' for l in cmt.splitlines()]
    header = wrap('=', 'Log : %s' % date).splitlines()
    return cmt + [''] + header + ['']

def in_directory(file, directory):
    #make both absolute    
    directory = os.path.join(os.path.realpath(directory), '')
    file = os.path.realpath(file)

    #return true, if the common prefix of both is equal to directory
    #e.g. /a/b/c/d.rst and directory is /a/b, the common prefix is /a/b
    return os.path.commonprefix([file, directory]) == directory

def move_to_eof():
    vim.current.window.cursor = (len(vim.current.buffer), 0)

EOF
endfunction

function! OpenLogForToday()
    call s:lazy_load()
pythonx << EOF
vim.command('edit ' + logfile)
if len(vim.current.buffer) <= 1:
    vim.current.buffer.append(header(DATE), 0)
    move_to_eof()
    vim.command("call feedkeys('i')")
EOF
endfunction

function! OpenNote(fname)
    call s:lazy_load()
pythonx << EOF
fname = vim.eval('a:fname')

if not fname.endswith('.rst'):
    fname = fname + '.rst'

if not in_directory(fname, notedir):
    fname = os.path.join(notedir, fname)

vim.command('edit ' + fname)

# Now check if the file is empty, if so append the header
if len(vim.current.buffer) == 1 and not len(vim.current.buffer[0]):
    base_name = os.path.splitext(os.path.basename(fname))[0]
    vim.current.buffer.append(wrap('=', base_name).splitlines() + [''], 0)
    move_to_eof()
    vim.command("call feedkeys('i')")
EOF
endfunction

function! InsertDateHeading()
    call 
endfunction

function ListNotes(arglead, cmdline, cursorpos)
    return system("find ". g:notedir . " -type f -name *.rst ")
endfunction

command! Date call InsertDateHeading()

command! -bang -nargs=? -complete=dir NoteFind call fzf#vim#files(g:notedir, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* NoteSearch call fzf#vim#grep("rg -g *.rst --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>)." ".g:notedir, 1, fzf#vim#with_preview(), <bang>0)
command! Log call OpenLogForToday()
command! -nargs=1 -complete=custom,ListNotes Note call OpenNote(<q-args>)


inoremap <expr> <f3> strftime("%Y-%m-%d")
nnoremap <expr> <f3> 'i'.strftime("%Y-%m-%d").''
cmap <f3> <C-R>=strftime("%Y-%m-%d")<CR>
