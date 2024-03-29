" A good chunk of this was grabbed from https://github.com/afnanenayet/nvim-dotfiles/blob/master/config/02.init.vim
" The rest is moved forward from my old vim configs

" Enable syntax highlighting
syntax on

" Fixes backspace
set backspace=indent,eol,start

" Enable line numbers
set nu

" Enable line/column info at bottom
set ruler
set cursorline " highlights current line

set scrolloff=10

" Autoindentation
set ai
filetype indent plugin on

" Copies using system clipboard
set clipboard+=unnamedplus

" Tab = 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set sta
set expandtab
set sts=4

" Except in make files, we need real tabs for those.
autocmd FileType make setlocal noexpandtab

set noshowmode

" Better Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable swap files
set nobackup
set nowritebackup
set noswapfile

" Automatic Woord Wrapping
set tw=100
set nowrap
set fo-=t

" Color Bar
set colorcolumn=110

" enable mouse support
set mouse=a mousemodel=popup

" markdown file recognition
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" relative line numbers
" Sets relative line numbers in normal mode, absolute line numbers in insert
" mode
set number
set relativenumber

" use ripgreg instead of grep
set grepprg=rg\ --vimgrep

" python packages in venv
let g:python_host_prog = '/Users/ilaird/.venv2/bin/python'
let g:python3_host_prog = '/Users/ilaird/.venv/bin/python'

" Set colors in terminal
" Solarized, dark, with true color support
set t_Co=256
set termguicolors
set background=dark
autocmd ColorScheme * set cursorline
autocmd ColorScheme * set cursorcolumn

" close vim if only window left is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" crontab filetype tweak (the way vim normally saves files confuses crontab
" so this workaround allows for editing
au FileType crontab setlocal bkc=yes

" Allow switching from unsaved buffers
set hidden

" Disable completion where available from ALE
" (not worth creating a separate file just for a one-liner)
let g:ale_completion_enabled = 0

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" terminal settings
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" Code Folding
set foldlevelstart=20
autocmd FileType python setlocal foldmethod=indent
autocmd FileType c,cpp,vim,xml,html,xhtml,typescript,javascript setlocal foldmethod=syntax
