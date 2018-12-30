let g:logdir = "~/.dotfiles/subrepos/documents"

function! OpenLog()
    let l:log = g:logdir . "/log.rst"
    exec 'edit ' . l:log

pythonx << EOF
import datetime
import re
import vim

now = datetime.datetime.now()
DATE = '%s-%s-%s' % (now.year, now.month, now.day)

header_sym = '='
date_header = '%s\n%s' % (DATE, header_sym*len(DATE))

additional_headings = ['Complete', 'Notes', 'Todo']
heading_sym = '^'

def append_lines(linebuffer, lines):
    for line in lines.splitlines():
        linebuffer.append(line)

def append_log(linebuffer):

    matches = re.findall(date_header, '\n'.join(linebuffer))

    if not matches:
        append_lines(linebuffer, date_header)
        linebuffer.append('')

        for heading in additional_headings:
            append_lines(linebuffer, heading)
            append_lines(linebuffer, heading_sym * len(heading))
            linebuffer.append('')

append_log(vim.current.buffer)
EOF
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
