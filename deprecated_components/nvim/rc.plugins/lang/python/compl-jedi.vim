let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 1
let g:jedi#smart_auto_mappings = 0
let g:jedi#documentation_command = ''

autocmd FileType python setlocal omnifunc=jedi#completions completeopt-=preview
autocmd FileType python call jedi#configure_call_signatures()

if !exists("g:neocomplete#sources#omni#input_patterns")
    let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists("g:deoplete#omni#sources#omni#input_patterns")
    let g:deoplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.python ='[^. \t]\.\w*\|\(from .* \|\)import \w*'
let g:deoplete#sources#omni#input_patterns.python ='[^. \t]\.\w*\|\(from .* \|\)import \w*'
