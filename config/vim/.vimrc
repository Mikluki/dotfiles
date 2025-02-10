if has('nvim') || has('termguicolors')
    let &t_SI = "\e[6 q"  " Sets cursor to bar in Insert mode
    let &t_EI = "\e[2 q"  " Sets cursor to block in Normal mode
endif

" Case insensitive search
set ignorecase

" Enable relative number
set relativenumber

" Enable break indent
set breakindent

" Keybindings
nnoremap yp :let @+ = expand("%:p")<CR>     " Copy full file path to clipboard
nnoremap yn :let @+ = expand("%:t")<CR>     " Copy file name to clipboard

vnoremap p P                                " Replace p with P in visual mode

nnoremap L $                                " Move to end of line with L (normal mode)
nnoremap H ^                                " Move to start of line with H (normal mode)
vnoremap L $                                " Move to end of line with L (visual mode)
vnoremap H ^                                " Move to start of line with H (visual mode)

omap l $                                    " Move to end of line with l in operator-pending mode
omap h ^                                    " Move to start of line with h in operator-pending mode

nnoremap U :redo<CR>                        " Redo with U
inoremap jj <Esc>                           " Exit insert mode with jj

nnoremap n nzzzv                            " Center screen after search (next match)
" nnoremap N Nzzzv                            " Center screen after search (previous match)

nnoremap J mzJ`z                            " Join lines with J and restore cursor position
nnoremap K mzi<CR><Esc>`z
