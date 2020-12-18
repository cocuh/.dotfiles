let g:deoplete#sources = {}
call deoplete#custom#option({
            \   'auto_complete_start_length': 3,
            \   'auto_complete_delay': 200,
            \   'smart_case': v:true,
            \})

inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

