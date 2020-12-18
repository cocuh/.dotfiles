let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
			\ 'auto_complete_delay': 100,
			\ 'start_case': v:true,
			\ })
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" close preview (information) window after completion
autocmd InsertLeave * silent! pclose!
