call plug#begin('~/.local/share/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'srcery-colors/srcery-vim'
Plug 'Shougo/denite.nvim'
Plug '/usr/local/opt/fzf'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
"Plug 'w0rp/ale'

"Plug 'Shougo/defx.nvim' ---- Keep an eye on this. Looks promising.
"Plug 'Shougo/deol.nvim'
"Plug 'rhysd/wallaby.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'HerringtonDarkholme/yats.vim'
"Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'leafgarland/typescript-vim'
"Plug 'zchee/deoplete-jedi'
"Plug 'davidhalter/jedi'
Plug 'uarun/vim-protobuf'

call plug#end()

" set runtimepath+=~/.local/share/nvim/plugged/deoplete.nvim/
