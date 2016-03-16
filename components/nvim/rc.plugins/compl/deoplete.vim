let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 3
let g:deoplete#sources = {}

inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#manual_complete()

