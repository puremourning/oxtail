# Tail Mode Plugin for Vim

A Vim plugin that allows you to put any buffer into "tail" mode, watching for file updates as if using `tail -f` or `less +F`.

## Features

- Enter tail mode for any buffer with a readable file.
- Replaces the current window's buffer with a terminal running `less +F`.
- Mimics `less` behavior: Ctrl-C to stop following, 'q' to exit.

## Installation

1. Copy `plugin/tail.vim` to `~/.vim/plugin/`.
2. Copy `doc/tail.txt` to `~/.vim/doc/`.
3. Run `:helptags ~/.vim/doc/` in Vim to generate help tags.

For plugin managers like vim-plug: >
    Plug 'your-repo/tail'
<

## Usage

### Commands

- `:Tail` - Enter tail mode for the current buffer.

### Mappings

- `<Plug>Tail` - Enter tail mode. Map it to a key, e.g.: >
    nmap <leader>t <Plug>Tail
<

In the terminal buffer:
- File updates are followed automatically.
- Press Ctrl-C to pause following.
- Press 'q' to exit and return to the original buffer view.

## Requirements

- Vim with terminal support (Vim 8.0+).

## License

MIT