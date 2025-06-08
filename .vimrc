source /usr/share/vim/vim82/defaults.vim

call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdtree'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

Plug 'posva/vim-vue'
Plug 'zivyangll/git-blame.vim'
Plug 'tpope/vim-commentary'
Plug 'nelsyeung/twig.vim'
Plug 'tobyS/pdv'
Plug 'gcorne/vim-sass-lint'
Plug 'nrocco/vim-phplint'
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'
Plug 'ap/vim-css-color'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'
Plug 'StanAngeloff/php.vim'
Plug 'arnaud-lb/vim-php-namespace'
Plug 'majutsushi/tagbar'
Plug 'raimondi/delimitmate'
Plug 'gko/vim-coloresque'
Plug 'dense-analysis/ale'
Plug 'vim-scripts/AnsiEsc.vim'
call plug#end()

" Source .vimrc on save
augroup autosourcing
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup END

" Set the Vim directory
let VIMRUNTIME="/usr/share/vim/vim82"

" Vimwiki settings
set nocompatible
filetype plugin on
syntax on
let g:vimwiki_text_ignore_newline = 0
let g:vimwiki_list = [
\ {
\   'path': '$HOME/vimwiki/wiki',
\   'path_html': '$HOME/vimwiki/html',
\   'template_path': '$HOME/vimwiki/templates',
\   'template_default': 'default',
\   'template_ext': '.html',
\   'diary_rel_path': 'work/planning/'
\  }
\]

" Lightline
set noshowmode
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'readonly', 'filename', 'modified' ]
      \   ],
      \   'right': [
      \     [ 'lineinfo' ],
      \     [ 'percent' ],
      \     [ 'filetype' ],
      \     [ 'fileencoding' ],
      \     [ 'fileformat' ],
      \   ]
      \ },
      \ }

" Change indent line and conceal levels
let g:indentLine_char = '|'
let g:indentLine_concealcursor = 'nc'
let g:indentLine_conceallevel = 2

" Set a visual line at columns 80 and 120
set colorcolumn=80,120

" Make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" Better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Gutentags
" let g:gutentags_ctags_tagfile = '.tags'
" let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
"                             \ '*.phar', '*.ini', '*.rst', '*.md',
"                             \ '*vendor/*/test*', '*vendor/*/Test*',
"                             \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
"                             \ '*var/cache*', '*var/log*']
" let g:gutentags_define_advanced_commands = 1
" let g:gutentags_modules = ['ctags', 'gtags_cscope']
" let s:vim_tags = expand('~/.cache/.tags')
" let g:gutentags_cache_dir = '~/.vim/gutentags'
" let g:gutentags_project_root = ['.git']
" let g:gutentags_cache_dir = expand('~/.cache/tags')
" Debugging
let g:gutentags_trace = 0

" Set a color scheme
colorscheme desertink

" Indentation
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent

" Put splits below and on the right
set splitbelow
set splitright

" Map some commands to uppercase, to prevent typos
command! W w
command! Q q
command! WQ wq
command! Wq wq

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Enable line numbers
set number relativenumber

" Enable the mouse
set mouse=a

" Fix scrolling down in ST
set ttymouse=sgr

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
noremap <Right> <NOP>

" Set the clipboard to the X Window clipboard
set clipboard=unnamedplus

" Format JSON
nmap =j :%!jq .<CR>

" NerdTree
noremap <C-o> :NERDTreeToggle<CR>
let NERDTreeIgnore=['CVS']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_phpctags_bin='~/.vim/phpctags'

" Move lines up or down
nnoremap K :m-2<CR>
nnoremap J :m+1<CR>

" Show or hide helper characters
nnoremap <F5> :set number! relativenumber!<CR>:IndentLinesToggle<CR>

" PHP namespace auto insert
function! IPhpInsertUse()
  call PhpInsertUse()
  call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>
let g:php_namespace_sort_after_insert = 1

" ALE linter
let g:ale_open_list = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_php_phpcs_executable = $HOME .'/.config/composer/vendor/bin/phpcs'
let g:ale_php_phpcs_standard = $HOME .'/.config/composer/vendor/drupal/coder/coder_sniffer/Drupal'
let g:ale_php_phpmd_executable = $HOME .'/.config/composer/vendor/bin/phpcs'

" Auto close quickfix windows if they're the only ones open
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END

" PDV
let g:pdv_template_dir = $HOME ."/.vim/plugged/pdv/templates_snip"
nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>

" Execute current line as a command
noremap Q !!$SHELL<CR>

" Git blame
nnoremap <C-b> :<C-u>call gitblame#echo()<CR>

" Switch between panes
nmap <silent> <C-k> <C-W>k
nmap <silent> <C-j> <C-W>j
nmap <silent> <C-h> <C-W>h
nmap <silent> <C-l> <C-W>l

" Auto-compile C code
autocmd BufWritePost *.{c,h,s,asm,cpp} :![[ -f Makefile ]] && sudo make

" auto-compile Sass
autocmd BufWritePost *.{sass,scss} :!if command -v grunt 2>/dev/null; then grunt sass:dev; fi
" Some sites use Gulp instead of Grunt
autocmd BufWritePost *nbdbiblion*,*.{sass,scss} :!if command -v gulp 2>/dev/null; then gulp prod; fi

" auto-compile LaTeX
autocmd BufWritePost *.{tex} :!pdflatex %

" Automatically convert Vimwiki files
autocmd BufWritePost *.wiki :silent VimwikiAll2HTML

" Custom settings for Mutt
autocmd BufNewFile,BufRead /tmp/*mutt* set noautoindent filetype=mail wm=0 tw=78 nonumber digraph nolist nopaste

" Custom settings for C code
autocmd BufNewFile,BufRead *.{c,h,s,asm,cpp} set cindent noexpandtab tabstop=4 shiftwidth=4

" Set PHP filetype for non-standard file types
augroup module
  autocmd BufRead,BufNewFile *.module  set filetype=php
  autocmd BufRead,BufNewFile *.theme   set filetype=php
  autocmd BufRead,BufNewFile *.install set filetype=php
  autocmd BufRead,BufNewFile *.test    set filetype=php
  autocmd BufRead,BufNewFile *.inc     set filetype=php
  autocmd BufRead,BufNewFile *.profile set filetype=php
  autocmd BufRead,BufNewFile *.view    set filetype=php
augroup END

" Persistent undo
if exists('&undofile') && !&undofile
  set undodir=~/.vim/undodir
  set undofile
endif
