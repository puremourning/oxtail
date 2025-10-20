function! Test_tail_mode_sets_variables()
  " Create a test file
  let testfile = tempname()
  call writefile(['line 1', 'line 2'], testfile)

  " Open the test file
  execute 'edit ' . testfile

  let orig_win = win_getid()
  let orig_buf = bufnr('%')

  " Enter tail mode
  Tail

  let term_buf = bufnr('%')

  " Assert that we switched to terminal
  call assert_equal('terminal', &buftype)
  call assert_equal(orig_win, b:orig_win)
  call assert_equal(orig_buf, b:orig_buf)

  " Send Ctrl-C and q to exit the terminal
  call term_sendkeys(term_buf, "\x03q")

  " Wait for the job to exit
  let job = term_getjob(term_buf)
  while job_status(job) == 'run'
    sleep 10m
  endwhile

  " Assert that we switched back to the original buffer
  call assert_equal(orig_buf, bufnr('%'))

  " Cleanup
  silent! %bwipe
  call delete(testfile)
endfunction

function! Test_tail_mode_window_switch()
  " Create a test file
  let testfile = tempname()
  call writefile(['line 1', 'line 2'], testfile)

  " Open the test file in a new window
  new
  execute 'edit ' . testfile

  let orig_win = win_getid()
  let orig_buf = bufnr('%')

  " Enter tail mode
  Tail

  let term_buf = bufnr('%')

  " Switch to another window
  wincmd p

  " Assert that the original window still exists
  call assert_true(win_id2win(orig_win) != 0)

  " Send Ctrl-C and q to exit the terminal
  call term_sendkeys(term_buf, "\x03q")

  " Wait for the job to exit
  let job = term_getjob(term_buf)
  while job_status(job) == 'run'
    sleep 10m
  endwhile

  " Assert that the original window now shows the original buffer
  call assert_equal(orig_buf, winbufnr(orig_win))

  " Cleanup
  silent! %bwipe
  call delete(testfile)
endfunction

function! RunTests()
  let tests = [
        \ 'Test_tail_mode_sets_variables',
        \ 'Test_tail_mode_window_switch'
        \ ]

  let failed = 0
  for test in tests
    let v:errors = []
    try
      call function(test)()
      if len(v:errors) > 0
        echo test . ' FAILED: ' . join(v:errors, '; ')
        let failed = 1
      else
        echo test . ' PASSED'
      endif
    catch
      echo test . ' FAILED: ' . v:exception
      let failed = 1
    endtry
  endfor

  if failed
    cquit
  else
    qall!
  endif
endfunction
