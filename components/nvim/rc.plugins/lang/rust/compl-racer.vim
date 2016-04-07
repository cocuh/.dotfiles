set hidden
let $RUST_SRC_PATH="/usr/src/rust/src"

if !exists("g:neocomplete#sources#omni#input_patterns")
    let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists("g:deoplete#sources#omni#input_patterns")
    let g:deoplete#sources#omni#input_patterns = {}
endif
if !exists("g:deoplete#sources#omni#functions")
    let g:deoplete#sources#omni#functions = {}
endif

let g:neocomplete#sources#omni#input_patterns.rust = '::\w*\|[^. \t]\.\w*\|use \w*'
let g:deoplete#sources#omni#input_patterns.rust = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:deoplete#sources#omni#functions.rust = 'racer#Complete'

