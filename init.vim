call plug#begin('~/.local/share/nvim/plugged')

function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !./install.py
    endif
endfunction

Plug 'Chiel92/vim-autoformat'
Plug 'bkad/CamelCaseMotion'
Plug 'fatih/vim-go'
Plug 'flazz/vim-colorschemes'
Plug 'jlanzarotta/bufexplorer'
Plug 'majutsushi/tagbar'
Plug 'pboettch/vim-cmake-syntax'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'w0rp/ale'

call plug#end()

" Plugin config.
let g:deoplete#enable_at_startup = 1

let g:ale_open_list = 1
let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ycm_filetype_blacklist = { 'java': 1 }

let g:formatdef_yapf = "'yapf -l '.a:firstline.'-'.a:lastline"
let g:formatters_python = ['yapf']

" UI options.
colorscheme zenburn

set list " Show unwanted whitespace characters.
set cursorline " Highlight current line.
set number " Show line numbers.

set colorcolumn=+1 " Highlight the column limit.
highlight ColorColumn ctermbg=238
highlight ColorColumn guibg=#444444

" Vertical/horizontal scroll off settings.
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

set laststatus=2

" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest

" Key mappings.
nnoremap Y y$
inoremap jj <ESC>
tnoremap <Esc> <C-\><C-n>
map <C-K> :Autoformat<CR>

" Explorer mappings.
nnoremap <f1> :BufExplorer<cr>
nnoremap <f2> :NERDTreeToggle<cr>
nnoremap <f3> :TagbarToggle<cr>

set pastetoggle=<f2>

" Q wraps the selection to fit the column limit.
noremap Q gq

" CamelCase motion should be the default. Note that the uppercase variants of
" these motions (e.g. cW) will still behave normally.
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" Don't continue comments when pushing o/O.
set formatoptions-=o 

" This changes the default behavior of cw from:
"
" foo_bar -> foo_bar
" ^              ^
"
" to:
"
" foo_bar -> foo_bar
" ^             ^
"
" Note that dw is left untouched.
nmap cw ce

" Make <c-l> clear the highlight as well as redraw.
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" Default formatting options.
set textwidth=80

" Make it easier to change indentation types and sizes.
function! UseSpaces()
    setlocal listchars=tab:»\ ,trail:⋅,nbsp:⋅
    setlocal expandtab
endfunction
command! UseSpaces call UseSpaces()

function! UseTabs()
    setlocal listchars=tab:\ \ ,trail:⋅,nbsp:⋅
    setlocal noexpandtab
endfunction
command! UseTabs call UseTabs()
function! IndentSize(size)
    exec "setlocal tabstop=" . a:size
    exec "setlocal shiftwidth=" . a:size
endfunction
command! Use2 call IndentSize(2)
command! Use4 call IndentSize(4)
command! Use8 call IndentSize(8)

UseSpaces
Use4

" Mechanical pieces.

" Undo/backup files settings
if has("win32")
    set undodir=~/vimfiles/undofiles
    set directory=~/vimfiles/backup//
else
    set undodir=~/.vim/undofiles
    set directory=~/.vim/backup//
endif

set undofile

" Hide buffers when not displayed.
set hidden

set autochdir

" Jump to last cursor position when opening a file.
" Don't do it when writing a commit log entry.
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction
