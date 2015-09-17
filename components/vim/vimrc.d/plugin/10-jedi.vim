NeoBundle 'davidhalter/jedi-vim'

let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 0
"let g:pymode_rope = 0

autocmd FileType python setlocal omnifunc=jedi#completions completeopt-=preview
