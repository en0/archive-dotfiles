" Copied from https://github.com/afnanenayet/nvim-dotfiles/blob/master/config/04.deoplete.vim

" deoplete options
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" disable autocomplete by default
let b:deoplete_disable_auto_complete=1
let g:deoplete_disable_auto_complete=1

call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_',
            \ 'disabled_syntaxes', ['Comment', 'String'])

" Close the completion dropdown on leave/done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Make the tab key work in completion menu
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

call deoplete#custom#option('sources', {
            \ 'typescript': ['LanguageClient'],
            \ 'python': ['LanguageClient'],
            \ 'python3': ['LanguageClient'],
            \ 'cpp': ['LanguageClient'],
            \ 'c': ['LanguageClient'],
            \ 'rust': ['LanguageClient'],
            \ 'vim': ['vim'],
            \})

" ignored sources
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ['buffer', 'around']
