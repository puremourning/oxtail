if exists('g:loaded_tail_plugin')
  finish
endif
let g:loaded_tail_plugin = 1

function! s:EnterTailMode()
  let l:file = expand('%:p')
  if empty(l:file) || !filereadable(l:file)
    echo "No readable file associated with the current buffer"
    return
  endif
  let l:orig_buf = bufnr('%')
  " Create a terminal buffer with less +F
  let l:buf = term_start(['less', '+F', l:file], {'hidden': 1, 'term_name': 'tail: ' . l:file, 'exit_cb': function('s:OnTermExit')})
  if l:buf == 0
    echo "Failed to create terminal"
    return
  endif
  " Switch the current window to the terminal buffer
  execute 'buffer ' . l:buf
  " Set buffer options
  setlocal bufhidden=wipe
  let b:tail_mode = 1
  let b:orig_buf = l:orig_buf
endfunction

" Define the <Plug> mapping for entering tail mode
noremap <unique> <Plug>Tail <Cmd>call <SID>EnterTailMode()<CR>

" Optional: Add a command for convenience
command! Tail call s:EnterTailMode()

function! s:OnTermExit(job, status)
  " Find the buffer for this job
  let l:buf = -1
  for b in range(1, bufnr('$'))
    if bufexists(b) && getbufvar(b, '&buftype') == 'terminal' && term_getjob(b) == a:job
      let l:buf = b
      break
    endif
  endfor
  if l:buf != -1
    let l:orig_buf = getbufvar(l:buf, 'orig_buf', -1)
    if l:orig_buf != -1
      " Switch to original buffer
      execute 'buffer ' . l:orig_buf
      checktime
    endif
  endif
endfunction
