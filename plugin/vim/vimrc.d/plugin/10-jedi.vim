NeoBundle 'davidhalter/jedi-vim'

let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#show_function_definition = 0

autocmd FileType python setlocal completeopt-=preview
