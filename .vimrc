" ~/.vimrc - Ian Laird 2015

" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" General Stuff
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

set hidden
set mouse=a
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set history=700
set undolevels=700
set nofoldenable
set noshowmode

" Make files need tabs.
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
autocmd FileType make setlocal noexpandtab

" Make search case insensitive
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable backup and swap files
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
set nobackup
set nowritebackup
set noswapfile

" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Key Bindings
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

let mapleader = ","

" Buffers
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
map <Leader>n :bp<CR>
map <Leader>m :bn<CR>
map <Leader>c :bd<CR>

" Windows
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
map <Leader>w= <C-w>=
map <Leader>wm :resize 100<CR>:vertical resize 85<CR>
map <Leader>wv :vertical resize 85<CR>
map <Leader>wo :only<CR>

map <Leader>w. :vertical resize -2<CR>
map <Leader>w, :vertical resize +2<CR>
map <Leader>wa :resize -2<CR>
map <Leader>wq :resize +2<CR>
map <Leader>wc <C-w>c

map <Leader>wh <C-w>h
map <Leader>wl <C-w>l
map <Leader>wk <C-w>k
map <Leader>wj <C-w>j

map <Leader>wmh <C-w>H
map <Leader>wml <C-w>L
map <Leader>wmk <C-w>K
map <Leader>wmj <C-w>J

" Flip to next window and make it full screen
map <Leader>wX <C-w>x:resize 100<CR>:vertical resize 85<CR>

" Onmipop
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Better navigation through omnicomplete options list
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Remove highlight of last search
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" Better code block indents
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
vnoremap < <gv
vnoremap > >gv

" Easier formatting of paragraphs
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
vmap Q gq
nmap Q gqap

" Toggle Spell check
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
map <F7> :setlocal spell! spelllang=en_us<CR>


" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Look and Feel
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

" Show whitespace
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=233 guibg=233
au InsertLeave * match ExtraWhitespace /\s\+$/

" Colors
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
set t_Co=256
syntax on
filetype off
filetype plugin indent on
colorscheme wallaby
set guifont=Liberation\ Mono\ for\ Powerline\ 13

" Document Width
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
set tw=79           " width of document (used by gd)
set nowrap          " don't automatically wrap on load
set fo-=t           " don't automatically wrap text when typing
set colorcolumn=80  " Set right bar
highlight ColorColumn ctermbg=233

" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Plugins
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

" Install Notes
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" vim-pathogen-git
" vim-colors-wallaby-git
" vim-airline-git
" vim-python-mode-git
" vim-fugitive-git
" vim-gitgutter-git
" vim-unite-git


" Airline Config
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
set laststatus=2
set ttimeoutlen=50
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:bufferline_echo = 0

" Python-Mode
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Map all Python-Mode keys to <Leader>p for Python ;)

" Generic Stuff
" ------------
" right column divider off.
let g:pymode_options_colorcolumn = 0
" Quickfix same size always, thanks
let g:pymode_quickfix_minheight = 4
let g:pymode_quickfix_maxheight = 4
" Generic document lookup
noremap <Leader>pD :PymodeDoc 


" Runtime
" ------------
" Disable pymode breakpoints. I like mine more
let g:pymode_breakpoint = 0
" Disable running. It sucks
let g:pymode_run = 1
" Map in a better breakpoint using ipdb (needs to be install)
noremap <Leader>pb Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>


" Lint
" ------------
" Values may be chosen from: `pylint`, `pep8`, `mccabe`, `pep257`, `pyflakes`.
let g:pymode_lint_checkers = ['pyflakes','pep8','mccabe']
" Run code check Manually
noremap <Leader>pc :call pymode#lint#check()<CR>
noremap <F5> :call pymode#lint#toggle()<CR>


" Rope
" ------------
" Find Usage
let g:pymode_rope_find_it_bind = '<Leader>pf'
" Goto Definition
let g:pymode_rope_goto_definition_bind = '<Leader>pg'
" Goto Documentation
let g:pymode_rope_show_doc_bind = '<Leader>pd'
" Refactor
let g:pymode_rope_rename_bind = '<Leader>pr'
" Undo Refactor
noremap <Leader>pu :PymodeRopeUndo<CR>
" Redo Refactor
noremap <Leader>pR :PymodeRopeRedo<CR>

" Initialize python project
noremap <Leader>pI :PymodeRopeNewProject<CR>
" Rescan project
noremap <Leader>pi :PymodeRopeRegenerate<CR>

" This might be worth looking into
" Load modules to autoimport by default       *'g:pymode_rope_autoimport_modules'*
""let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime'])
" Offer to unresolved import object after completion.
""let g:pymode_rope_autoimport_import_after_complete = 0
"
" Fugitive config
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Map all unite stuff bound to <Leader>g. G for git ;)

" General usage
" ------------
noremap <Leader>gd :Gdiff<CR>


" Unite config
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Map all unite stuff bound to <Leader>f. F for files ;)

" General usage
" ------------
noremap <Leader>ff :Unite file<CR>
noremap <Leader>fb :Unite buffer<CR>
noremap <Leader>fc :UniteClose<CR>

" Custom Menus
" ------------
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.git = {
    \ 'description' : '            gestionar repositorios git
        \                            ⌘ [espacio]g',
    \}
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ tig                                                        ⌘ ,gt',
        \'normal ,gt'],
    \['▷ git status       (Fugitive)                                ⌘ ,gs',
        \'Gstatus'],
    \['▷ git diff         (Fugitive)                                ⌘ ,gd',
        \'Gdiff'],
    \['▷ git commit       (Fugitive)                                ⌘ ,gc',
        \'Gcommit'],
    \['▷ git log          (Fugitive)                                ⌘ ,gl',
        \'exe "silent Glog | Unite quickfix"'],
    \['▷ git blame        (Fugitive)                                ⌘ ,gb',
        \'Gblame'],
    \['▷ git stage        (Fugitive)                                ⌘ ,gw',
        \'Gwrite'],
    \['▷ git checkout     (Fugitive)                                ⌘ ,go',
        \'Gread'],
    \['▷ git rm           (Fugitive)                                ⌘ ,gr',
        \'Gremove'],
    \['▷ git mv           (Fugitive)                                ⌘ ,gm',
        \'exe "Gmove " input("destino: ")'],
    \['▷ git push         (Fugitive, salida por buffer)             ⌘ ,gp',
        \'Git! push'],
    \['▷ git pull         (Fugitive, salida por buffer)             ⌘ ,gP',
        \'Git! pull'],
    \['▷ git prompt       (Fugitive, salida por buffer)             ⌘ ,gi',
        \'exe "Git! " input("comando git: ")'],
    \['▷ git cd           (Fugitive)',
        \'Gcd'],
    \]
nnoremap <Leader>fg :Unite -silent -start-insert menu:git<CR>
