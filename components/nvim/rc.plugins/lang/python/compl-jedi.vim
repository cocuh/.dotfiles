let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 1

autocmd FileType python setlocal omnifunc=jedi#completions completeopt-=preview
autocmd FileType python call jedi#configure_call_signatures()

if !exists("g:neocomplete#sources#omni#input_patterns")
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.python ='[^. \t]\.\w*\|\(from .* \|\)import \w*'

