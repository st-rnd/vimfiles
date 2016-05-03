"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"activate pathogen
call pathogen#infect()

function! SourceIfExists(path)
	if filereadable(glob(a:path))
		exec ":source " . a:path
	endif
endfunction

function! EditFtpluginForCurrentFile()
	exec "edit ~/.vim/ftplugin/" . &ft . ".vim"
endfunction
command! Ef call EditFtpluginForCurrentFile()

function! EditVimrc()
	split $MYVIMRC
endfunction
command! Ev call EditVimrc()

function! SourceVimrc()
	source $MYVIMRC
endfunction
command! Sv call SourceVimrc()

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2
set clipboard=unnamedplus

"tell the term has 256 colors
set t_Co=256

onoremap p i(

set autochdir

" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest

" Limit popup menu height
set pumheight=15

" SuperTab option for context aware completion
let g:SuperTabDefaultCompletionType="context"

" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto=0

" Show clang errors in the quickfix window
let g:clang_complete_copen=1

" Close preview window after completion
let g:clang_close_preview=1

" Y (upper case) persists localvimrc selection.
let g:localvimrc_persistent=1

colorscheme zenburn
highlight ColorColumn ctermbg=238
highlight ColorColumn guibg=#444444

" Use a font that supports a wider range of UTF-8 characters
set guifont=DejaVu\ Sans\ Mono\ 12
set guifontwide=DejaVu\ Sans\ Mono\ 12

set textwidth=80

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set number      "show line numbers

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

set list
" Use spaces for indentation by default.
UseSpaces

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

set wrap        "dont wrap lines
set linebreak   "wrap lines at convenient points

let g:clang_library_path = '/usr/local/lib'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
"let g:syntastic_cpp_checkers = ['cpplint', 'clang_check', 'clang_tidy']
let g:syntastic_cpp_checkers = ['cpplint']

let g:syntastic_python_checkers = ['pylint', 'pep8']

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

if v:version >= 703
	" undo/backup files settings
	if has("win32")
		set undodir=~/vimfiles/undofiles
		set directory=~/vimfiles/backup
	else
		set undodir=~/.vim/undofiles
		set directory=~/.vim/backup
	endif

	set undofile

	set colorcolumn=+1 "mark the ideal max text width
	set cursorline
endif

"default indent settings
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

if &term =~ '^screen'
	" tmux will send xterm-style keys when its xterm-keys option is on
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

"hide buffers when not displayed
set hidden

"source ~/.vim/statusline.vim
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/

set laststatus=2

"nerdtree settings
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40

" real man's escape
inoremap jj <ESC>

" Grep for the word under the cursor (gw is *exactly* the word), don't show the
" full screen results, don't auto open in the current window, open the results,
" redraw because terminals are awful, switch back to previously selected window.
nnoremap gr :silent grep! <cword> *<CR>:copen<CR>:redraw!<CR>:winc p<CR>
nnoremap gw :silent grep! '\b<cword>\b' *<CR>:copen<CR>:redraw!<CR>:winc p<CR>

map <C-K> :Autoformat<cr>
let g:formatdef_autopep8 = "'autopep8 - --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['autopep8']

"explorer mappings
nnoremap <f1> :BufExplorer<cr>
nnoremap <f2> :NERDTreeToggle<cr>
nnoremap <f3> :TagbarToggle<cr>

" CamelCase motion should be the default. Note that the uppercase variants of
" these motions (e.g. cW) will still behave normally.
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

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

set pastetoggle=<f2>

"source project specific config files
runtime! projects/**/*.vim

" make [[ and friends behave with K&R
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

nnoremap <C-j> :bn<CR>
nnoremap <C-k> :bp<CR>

vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"visual search mappings
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
	if &filetype !~ 'svn\|commit\c'
		if line("'\"") > 0 && line("'\"") <= line("$")
			exe "normal! g`\""
			normal! zz
		endif
	end
endfunction

"spell check when writing commit logs
autocmd filetype svn,*commit* setlocal spell
autocmd filetype svn,*commit* setlocal tw=70

" Enable syntax highlighting for LLVM files. To use, copy
" utils/vim/llvm.vim to ~/.vim/syntax .
augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
augroup END

" Enable syntax highlighting for tablegen files. To use, copy
" utils/vim/tablegen.vim to ~/.vim/syntax .
augroup filetype
  au! BufRead,BufNewFile *.td     set filetype=tablegen
augroup END

"http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
"hacks from above (the url, not jesus) to delete fugitive buffers when we
"leave them - otherwise the buffer list gets poluted
"
"add a mapping on .. to view parent tree
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost fugitive://*
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

call SourceIfExists('~/.vim/localconfig.vim')
