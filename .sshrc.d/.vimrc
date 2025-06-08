" Enable syntax highlighting
syntax on

" Change indent line
let g:indentLine_char = '|'

" Set a visual line at column 80
set colorcolumn=80,120

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:airline_theme='airlineish'

" Automagically indent lines
set autoindent

" Map some commands to uppercase, to prevent typos
command! W w
command! Q q
command! WQ wq

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Set tab to two spaces
set tabstop=4
set softtabstop=2
set shiftwidth=2
set expandtab

" Set tab on C files
autocmd Filetype c setlocal noexpandtab

" Enable line numbers
set number relativenumber

" Set a scroll offset
set scrolloff=10

" Enable the mouse
set mouse=a

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Move lines up or down
nnoremap K :m-2<CR>
nnoremap J :m+1<CR>

" Execute current line as a command
noremap Q !!$SHELL<CR>

" Switch between panes
nmap <silent> <C-k> <C-W>k
nmap <silent> <C-j> <C-W>j
nmap <silent> <C-h> <C-W>h
nmap <silent> <C-l> <C-W>l

" Custom syntax settings
autocmd BufNewFile,BufRead /tmp/*mutt* set noautoindent filetype=mail wm=0 tw=78 nonumber digraph nolist nopaste
autocmd BufNewFile,BufRead *.theme set syntax=php



" Set directory-wise configuration.
" Search from the directory the file is located upwards to the root for
" a local configuration file called .lvimrc and sources it.
"
" The local configuration file is expected to have commands affecting
" only the current buffer.

function SetLocalOptions(fname)
	let dirname = fnamemodify(a:fname, ":p:h")
	while "/" != dirname
		let lvimrc  = dirname . "/.lvimrc"
		if filereadable(lvimrc)
			execute "source " . lvimrc
			break
		endif
		let dirname = fnamemodify(dirname, ":p:h:h")
	endwhile
endfunction

au BufNewFile,BufRead * call SetLocalOptions(bufname("%"))
