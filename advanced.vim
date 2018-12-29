" Use the the_silver_searcher if possible
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif
