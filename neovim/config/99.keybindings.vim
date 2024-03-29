let mapleader = ","

" Buffer Nav
map <Leader>n :bp<CR>
map <Leader>m :bn<CR>
map <Leader>c :bp<CR>:bd #<CR>
map <Leader>b :call fzf#run({
    \ 'source': map(range(1, bufnr('$')), 'bufname(v:val)'),
    \ 'sink': 'e', 'down': '30%',
    \ })<CR>

" File Nav
map <Leader>f :FZF<CR>
map <leader>e :NERDTreeToggle<CR>
map <C-p> :NERDTreeFocus<CR>

" Searching
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" Better indent control
vnoremap < <gv
vnoremap > >gv

" Format Text
vmap Q gq
nmap Q gqap

" Spelling! ya.
map <F7> :setlocal spell! spelllang=en_us<CR>

" Because you always forget
command WW w !sudo tee %

" Typescript extras
autocmd FileType typescript map <F2> :TSRename<CR>
autocmd FileType typescript map <Leader>q :Denite menu:qlts<CR>
