let s:dein_plugin_path = '~/.dotfiles/components/nvim/plugins'

augroup plugin_hook
    autocmd!
augroup END

function s:_hook_path(plugin) "{{{
    return s:dein_plugin_path."/".v:val."-after.vim"
endfunction "}}}

function s:register_hook(plugin) "{{{
    execute 'autocmd MyAutoCmd User' 'dein#source#' . a:plugin .
                \ 'source '.s:_hook_path(a:plugin)
endfunction "}}}

let s:plugins = map(keys(dein#get()), 'v:val')
call map(deepcopy(s:plugins), 's:register_hook(v:val)')
let s:conf_paths = map(deepcopy(s:plugins), 's:dein_plugin_path."/".v:val.".vim"')
runtime! map(deepcopy(s:conf_paths), 'v:val')
