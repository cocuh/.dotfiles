let s:dein_hook_path = '~/.dotfiles/components/nvim/hooks'

function s:hook_path(filename) "{{{
    execute 'autocmd MyAutoCmd User' 'dein#source#' . g:dein#name .
                \ 'source '. s:dein_hook_path .'/' . a:filename
endfunction "}}}

if dein#tap('deoplete.nvim') && has('nvim') "{{{
    let g:deoplete#enable_at_startup = 1
    call s:hook_path('deoplete.vim')
endif "}}}

if dein#tap('neocomplete.vim') && has('lua') "{{{
    let g:neocomplete#enable_at_startup = 1
    call s:hook_path('neocomple.vim')
endif "}}}

if dein#tap('vimfiler') "{{{
    call s:hook_path('vimfiler')
endif "}}}

if dein#tap('neosnippet.vim') "{{{
    call s:hook_path('neosnippet.vim')
endif "}}}

if dein#tap('vimshell.vim') "{{{
    call s:hook_path('vimshell.vim')
endif "}}}

if dein#tap('vinarize.vim') "{{{
    let g:vinarise_enable_auto_detect = 1
endif "}}}

if dein#tap('vim-airline') "{{{
endif "}}}

if dein#tap('neosnippet') "{{{
endif "}}}

if dein#tap('vim-quickrun') "{{{
    call s:hook_path('quickrun.vim')
endif "}}}

if dein#tap('crystal') "{{{
endif "}}}

if dein#tap('python-jedi') "{{{
endif "}}}

if dein#tap('rust') "{{{
endif "}}}

if dein#tap('rust-racer') "{{{
endif "}}}

if dein#tap('github-complete') "{{{
endif "}}}

if dein#tap('csv') "{{{
endif "}}}

