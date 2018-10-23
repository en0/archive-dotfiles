call plug#begin('~/.local/share/nvim/plugged')
Plug '/usr/local/opt/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/denite.nvim'
Plug 'rhysd/wallaby.vim'
Plug 'w0rp/ale'
call plug#end()

set hidden
set mouse=a
set hlsearch
set incsearch
set ignorecase
set smartcase
set number
set noshowmode
set nobackup
set nowritebackup
set noswapfile
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

let g:python3_host_prog = '/Users/ilaird/.venv/bin/python'
let g:deoplete#enable_at_startup = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_banner = 0
let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_winsize   = 15
let g:netrw_browse_split = 4

let mapleader = ","
map <Leader>n :bp<CR>
map <Leader>m :bn<CR>
map <Leader>c :bp<CR>:bd #<CR>
map <Leader>f :FZF<CR>
map <leader>e :Vexplore<CR>
noremap - :Explore .<CR>
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>
vnoremap < <gv
vnoremap > >gv
vmap Q gq
nmap Q gqap
map <F7> :setlocal spell! spelllang=en_us<CR>

command WW w !sudo tee %
colorschem wallaby

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=233 guibg=233
autocmd FileType make setlocal noexpandtab
autocmd FileType typescript map <F2> :TSRename<CR>
autocmd FileType typescript map <Leader>q :Denite menu:qlts<CR>

let s:menus = {}
let s:menus.qlts = { 'description': 'Quick List options for Typescript' }
let s:menus.qlts.command_candidates = [
    \ ['Find References', 'TSRef'],
    \ ['Goto Definition', 'TSDef'],
    \ ['Goto Type Definition', 'TSTypeDef'],
    \ ['Rename Symbol', 'TSRename'],
    \ ['Show Documentation', 'TSDoc'],
    \ ['Show Type', 'TSType'],
    \ ['Add Import', 'TSImport'],
    \ ]
call denite#custom#var('menu', 'menus', s:menus)

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
