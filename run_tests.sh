#!/bin/bash

# Run the tail plugin tests
vim -Nu test_vimrc -S tests/tail.vim -c 'call RunTests()'

exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Tests failed with exit code $exit_code"
  exit 1
else
  echo "All tests passed"
  exit 0
fi
